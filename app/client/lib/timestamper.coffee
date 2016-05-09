zipGenerator = require './zip/zip_generator'
FileReaderStream = require 'filereader-stream'

validator = require './validator'
digest = require './digest_generator'


class Timestamper

    constructor: () ->
        @zipHandler = new zipGenerator.ZipGenerator()

    generateHash: (file) ->
#        Returns a promise
        zipGen = @zipHandler
        return new Promise(
            (resolve, reject) ->
                if validator.fileIsValid(file)
                    zipGen.addFile file

                    digestStream = FileReaderStream file
                    digest.generateDigestWithStream digestStream, (error, result) ->
                        if error
                            reject error
                        else
                            resolve result
                else
                    reject 'Hash could not be generated. Check that the input file is correct.'
        )

    timestamp: (hash, filename) ->
#        Returns a promise
        zipGen = @zipHandler
        return new Promise(
            (resolve, reject) ->
                if validator.validArgsForTimestamp(hash)
                    Meteor.call 'server/timestamp', hash, (error, result) ->
                        if not error
                            resultArr = []
                            $.each result, (name, value) ->
                                resultArr[name] = value

                            zipGen.addBuffer "timestamp.tsr", resultArr
                            zipGen.generate().then (blob) ->
                                zipName = filename.substr(0, filename.lastIndexOf('.')) or filename
                                zipName += ' - Timestamped by ResearchDate.zip'
                                resolve {
                                    data: blob,
                                    zipName: zipName
                                }
                            , (err) ->
                                reject err
                        else
                            reject error.message
                else
                    reject ''
        )


exports.Timestamper = Timestamper
