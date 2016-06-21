zipGenerator = require './zip/zip_generator'
FileReaderStream = require 'filereader-stream'
validator = require './validator'
digest = require './digest_generator'
servers = require '../../lib/asn1/tsa_servers.coffee'


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

    timestamp: (hash, filename, tsaUrls) ->
#        Returns a promise
        zipGen = @zipHandler
        return new Promise(
            (resolve, reject) ->
                if validator.validArgsForTimestamp(hash)
                    Meteor.call 'server/timestamp', hash, tsaUrls, (error, result) ->
                        if not error
                            NProgress.inc()
                            for item in result
                                resultArr = (value for _, value of item.response)
                                bufferName = servers.tsa_servers[item.tsa] + '.tsr'
                                zipGen.addBuffer bufferName, resultArr

                            zipGen.generate().then (blob) ->
                                zipName = filename.substr(0, filename.lastIndexOf('.')) or filename
                                zipName += ' - Timestamped by ResearchDate.zip'
                                resolve {
                                    data: blob,
                                    zipName: zipName
                                }
                                NProgress.set(0.9)
                            , (err) ->
                                reject err
                        else
                            reject error.message
                else
                    reject ''
        )


exports.Timestamper = Timestamper
