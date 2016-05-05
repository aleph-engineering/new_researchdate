FileReaderStream = require 'filereader-stream'
StreamToBuffer = require 'stream-to-buffer'
JSZip = require 'jszip'

digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'
validator = require '../../lib/validator'


Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        zipZone = $('#zipInput')
        files = zipZone.get(0).dropzone.getAcceptedFiles()

        if validator.validArgsForVerification(files[0])
            fileStream = FileReaderStream files[0]
            StreamToBuffer fileStream, (error, fileBuffer) ->
                unless error
                    zip = new JSZip()
                    tsrZippedFile = null
                    originalZippedFile = null
                    zip.loadAsync(fileBuffer).then((zip) ->
                        zip.forEach (relativePath, file) ->
                            filename = file.name
                            fileExt = filename.substr(filename.lastIndexOf('.'), filename.length)
                            if fileExt is '.tsr'
                                tsrZippedFile = file
                            else
                                originalZippedFile = file

                        throw 'The zip does not contain a timestamp archive' unless tsrZippedFile?
                        throw 'The zip does not contain a timestamped artifact' unless originalZippedFile?

                        tsrPromise = tsrZippedFile.async('nodebuffer')
                        artifactPromise = originalZippedFile.nodeStream()
                        return Promise.all([tsrPromise, artifactPromise])
                    ).then((values) ->
                        digest.generateDigestWithStream values[1], (error, result)->
                            if error
                                console.log error
                            else
                                verification(result, values[0])
                    )
        else
            zipZone.addClass('error') if !validator.fileExist(zip)

}

verification = (result, tsr)->
    tsVerifier = new verifier.TimestampVerifier result, tsr
    if tsVerifier.verify() is true
        Toast.info(i18n('verification.messages.info'), '', {width: 800})
    else
        Toast.error(i18n('verification.messages.error'), '', {width: 800})


Template.Verification.helpers {

}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->
    dropzoneForZip = Dropzone.forElement('#zipInput')
    dropzoneForZip.options.acceptedFiles = '.zip'
    dropzoneForZip.on 'addedfile', (file)->
        $('#zipInput').removeClass('error')

Template.Verification.onDestroyed ->
