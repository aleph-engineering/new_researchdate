digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $('#tsr-hash').get(0).dropzone.getAcceptedFiles()
        origin = $('#original-file').get(0).dropzone.getAcceptedFiles()
        digest.generateDigest origin[0], (error, result)->
            if error
                console.log error
            else
                verification(result, tsr)
}

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

Template.Verification.onDestroyed ->


