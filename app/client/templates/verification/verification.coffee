FileReaderStream = require 'filereader-stream'
StreamToBuffer = require 'stream-to-buffer'

digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'
validator = require '../../lib/validator'


Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        zipZone = $('#zipInput')
        zip = zipZone.get(0).dropzone.getAcceptedFiles()

}

verification = (result, tsr)->
    file = tsr[0]
    reader = new FileReader()
    reader.onload = (evt) ->
        if evt.target.error == null
            responseBuffer = new Buffer evt.target.result
            tsVerifier = new verifier.TimestampVerifier result, responseBuffer
            if tsVerifier.verify() is true
                Toast.info(i18n('verification.messages.info'), '', {width: 800})
            else
                Toast.error(i18n('verification.messages.error'), '', {width: 800})
    reader.readAsArrayBuffer file


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


