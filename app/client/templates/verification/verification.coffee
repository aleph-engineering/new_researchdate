digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'
validator = require '../../lib/validator'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        hashZone = $('#tsr-hash')
        originalArtefactZone = $('#original-file')
        tsr = hashZone.get(0).dropzone.getAcceptedFiles()
        origin = originalArtefactZone.get(0).dropzone.getAcceptedFiles()

        if validator.validArgsForVerification(tsr, origin)
            digest.generateDigest origin[0], (error, result)->
                if error
                    console.log error
                else
                    verification(result, tsr)
        else
            hashZone.addClass('error') if !validator.fileExist(tsr)
            originalArtefactZone.addClass('error') if !validator.fileExist(origin)

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
    dropzoneForTsr = Dropzone.forElement('#tsr-hash')
    dropzoneForTsr.options.acceptedFiles = '.tsr'
    dropzoneForTsr.on 'addedfile', (file)->
        $('#tsr-hash').removeClass('error')
    Dropzone.forElement('#original-file').on 'addedfile', (file)->
        $('#original-file').removeClass('error')

Template.Verification.onDestroyed ->


