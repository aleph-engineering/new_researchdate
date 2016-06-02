verificator = require '../../lib/verificator'


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

    $('#step-number').on 'click', ->
        $('#step-number .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#step-button').on 'click', ->
        if validator.dropzoneEmpty(dropzoneForZip)
            $('#zipInput').addClass('error')
        else
            $('#step-button .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    dropzoneForZip.on 'addedfile', ->
        $('#zipInput').removeClass('error')
        $('#step-button :button').prop('disabled', false)

    dropzoneForZip.on 'removedfile', (file)->
        $('#zipInput').addClass('error')

        $('#step-button :button').prop('disabled', true)

        $('#step-button .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/check.svg', '/img/empty-check.svg'

Template.Verification.onDestroyed ->
