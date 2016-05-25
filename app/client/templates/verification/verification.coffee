verificator = require '../../lib/verificator'


Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        zipZone = $('#zipInput')
        files = zipZone.get(0).dropzone.getAcceptedFiles()

        ver = new verificator.Verificator()

        #        isBusy.set true

        ver.verify(files[0]).then((result) ->
#            isBusy.set false
            if result is true
                Toast.info(i18n('verification.messages.info'), '', {width: 800})
            else
                Toast.error(i18n('verification.messages.error'), '', {width: 800})
        ).catch((error) ->
#            isBusy.set false
            if error is 'TSR_MISSING'
                Toast.error(i18n('verification.messages.not_tsr'), '', {width: 800})
            else if error is 'ARTIFACT_MISSING'
                Toast.error(i18n('verification.messages.not_artifact'), '', {width: 800})
            else if error.toString().length > 0
                Toast.error(error, '', {width: 800})
            else
                zipZone.addClass('error')
        )

}

Template.Verification.helpers {

}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->
    dropzoneForZip = Dropzone.forElement('#zipInput')
    dropzoneForZip.options.acceptedFiles = '.zip'
    dropzoneForZip.on 'addedfile', ->
        $('#zipInput').removeClass('error')

Template.Verification.onDestroyed ->
