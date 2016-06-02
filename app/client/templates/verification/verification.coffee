verificator = require '../../lib/verificator'
validator = require '../../lib/validator'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        zipZone = $('#zipInput')
        files = zipZone.get(0).dropzone.getAcceptedFiles()

        ver = new verificator.Verificator()

        ver.verify(files[0]).then((result) ->
            if result is true
                Toast.info(i18n('verification.messages.info'), '', {width: 800})
            else
                Toast.error(i18n('verification.messages.error'), '', {width: 800})
        ).catch((error) ->
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

    $('#step-dropzone-verify').on 'click', ->
        $('#step-dropzone-verify .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#step-button-verify').on 'click', ->
        if validator.dropzoneEmpty(dropzoneForZip)
            $('#zipInput').addClass('error')
        else
            $('#step-button-verify .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    dropzoneForZip.on 'addedfile', ->
        $('#zipInput').removeClass('error')
        $('#step-button-verify :button').prop('disabled', false)

    dropzoneForZip.on 'removedfile', ()->
        $('#zipInput').addClass('error')

        $('#step-button-verify :button').prop('disabled', true)

        $('#step-button-verify .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/check.svg', '/img/empty-check.svg'

    $('#step-button-verify').on 'click', ->
        $('#step-number .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

Template.Verification.onDestroyed ->
