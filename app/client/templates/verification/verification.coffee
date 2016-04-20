digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        hashZone = $('#tsr-hash')
        originalArtefactZone = $('#original-file')
        tsr = hashZone.get(0).dropzone.getAcceptedFiles()
        origin = originalArtefactZone.get(0).dropzone.getAcceptedFiles()

        if valid(tsr, origin)
            digest.generateDigest origin[0], (error, result)->
                if error
                    console.log error
                else
                    verification(result, tsr)
        else
            hashZone.addClass('error') if tsr.length is 0
            originalArtefactZone.addClass('error') if origin.length is 0

}

valid = (tsr, original)->
    tsr.length > 0 && original.length > 0

verification = (result, tsr)->
    if tsr.length > 0
        file = tsr[0]
        reader = new FileReader()
        reader.onload = (evt) ->
            if evt.target.error == null
                responseBuffer = new Buffer evt.target.result
                verify = verifier.verifyTimestamp(result, responseBuffer)
                if verify is true
                    Toast.info(i18n('verification.messages.info'), '', {width: 800})
                else
                    Toast.error(i18n('verification.messages.error'), '', {width: 800})
        reader.readAsArrayBuffer file


Template.Verification.helpers {

}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->
    Dropzone.forElement('#tsr-hash').on 'addedfile', (file)->
        $('#tsr-hash').removeClass('error')
    Dropzone.forElement('#original-file').on 'addedfile', (file)->
        $('#original-file').removeClass('error')
Template.Verification.onDestroyed ->


