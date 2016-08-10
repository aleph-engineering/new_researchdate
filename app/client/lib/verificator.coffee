zipReader = require './zip/zip_reader'
validator = require './validator'
digest = require './digest_generator'
verifier = require '../../lib/timestamp_verification'

class Verificator

    constructor: () ->
        @zipHandler = new zipReader.ZipReader()

    verify: (zipFile) ->
        reader = @zipHandler
        return new Promise(
            (resolve, reject) ->
                if validator.validArgsForVerification(zipFile)
                    reader.load(zipFile).then((files) ->
                        tsrZippedFiles = []
                        originalZippedFile = null

                        files.forEach (element, index, array) ->
                            fileExt = element.substr(element.lastIndexOf('.'), element.length)
                            if fileExt is '.tsr'
                                tsrZippedFiles.push reader.getFile element, false
                            else if not originalZippedFile?
                                originalZippedFile = reader.getFile element, true

                        if tsrZippedFiles.length is 0
                            reject 'TSR_MISSING'
                        else if not originalZippedFile?
                            reject 'ARTIFACT_MISSING'

                        else
                            Promise.all([tsrZippedFiles, originalZippedFile]).then((values) ->
                                artifactStream = values[1]

                                digest.generateDigestWithStream artifactStream, (error, result) ->
                                    if error
                                        reject error
                                    else
                                        for tsrBuffer in values[0]
                                            tsrBuffer.then((val) =>
                                                tsVerifier = new verifier.TimestampVerifier result, val
                                                resolve tsVerifier.verify()
                                        )
                            ).catch((error) ->
                                reject error
                            )
                    ).catch((error) ->
                        reject error
                    )
                else
                    reject ''
        )


exports.Verificator = Verificator
