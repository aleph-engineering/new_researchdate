verificator = require '../../lib/verificator'
validator = require '../../lib/validator'

imageV1 = new ReactiveVar '/img/empty-check.svg'
imageV2 = new ReactiveVar '/img/empty-check.svg'
label= new ReactiveVar 'pepe'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        zipZone = $('#zipInput')
        files = zipZone.get(0).dropzone.getAcceptedFiles()

        ver = new verificator.Verificator()

        ver.verify(files[0]).then((result) ->
            if false in result
                label.set i18n('verification.messages.error')
                $('#step-messages').css 'background-color', '#cc0000'
            else
                label.set i18n('verification.messages.info')
                $('#step-messages').css 'background-color', '#02a349'
        ).catch((error) ->
            if error is 'TSR_MISSING'
                label.set i18n('verification.messages.not_tsr')
                $('#step-messages').css 'background-color', '#cc0000'
            else if error is 'ARTIFACT_MISSING'
                label.set i18n('verification.messages.not_artifact')
                $('#step-messages').css 'background-color', '#cc0000'
            else if error.toString().length > 0
                label.set(error)
                $('#step-messages').css 'background-color', '#cc0000'
            else
                zipZone.addClass('error')
        )

    'click #step-dropzone-verify': (e) ->
        imageV1.set('/img/check.svg')

    'click #step-button-verify': (e) ->
        dropzoneForZip = Dropzone.forElement('#zipInput')

        if validator.dropzoneEmpty dropzoneForZip
            $('#zipInput').addClass 'error'
        else
            imageV2.set('/img/check.svg')
}

Template.Verification.helpers {

    imageStepV1: ->
        imageV1.get()
    imageStepV2: ->
        imageV2.get()

    labelMsg: ->
        label.get()
}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->
    dropzoneForZip = Dropzone.forElement('#zipInput')
    dropzoneForZip.options.acceptedFiles = '.zip'

    dropzoneForZip.on 'addedfile', (file)->
        $(".dz-progress").remove();
        $('#step-button-verify :button').prop 'disabled', false
        $('#zipInput').removeClass 'error'
        $('#step-button-verify :button').prop 'disabled', false

    dropzoneForZip.on 'error', (file, response)->
        $('#zipInput').addClass('error')
        $('#step-button-verify :button').prop 'disabled', true

        imageV2.set('/img/empty-check.svg')

    dropzoneForZip.on 'removedfile', (file)->
        if validator.dropzoneValid dropzoneForZip
            $('#step-button-verify :button').prop 'disabled', false
            $('#zipInput').removeClass 'error'
        else
            $('#step-button-verify :button').prop('disabled', true)
            $('#zipInput').addClass('error')
            imageV2.set('/img/empty-check.svg')

    dropzoneForZip.on 'uploadprogress', () ->
        $(".dz-progress").remove();

Template.Verification.onDestroyed ->
