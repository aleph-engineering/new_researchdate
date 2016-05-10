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
                        tsrZippedFile = null
                        originalZippedFile = null
                        files.forEach (element, index, array) ->
                            fileExt = element.substr(element.lastIndexOf('.'), element.length)
                            if fileExt is '.tsr'
                                tsrZippedFile = reader.getFile element, false
                            else if not originalZippedFile?
                                originalZippedFile = reader.getFile element, true

                        if not tsrZippedFile?
                            reject 'TSR_MISSING'
                        else if not originalZippedFile?
                            reject 'ARTIFACT_MISSING'
                        else
                            Promise.all([tsrZippedFile, originalZippedFile]).then((values)->
                                tsrBuffer = values[0]
                                artifactStream = values[1]

                                digest.generateDigestWithStream artifactStream, (error, result)->
                                    if error
                                        reject error
                                    else
                                        tsVerifier = new verifier.TimestampVerifier result, tsrBuffer
                                        resolve tsVerifier.verify()
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
