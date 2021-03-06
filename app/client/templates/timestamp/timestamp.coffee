FileSaver = require 'browser-filesaver'
timestamper = require '../../lib/timestamper'
validator = require '../../lib/validator'

Session.setDefault 'artifactHash', 'NONE'
Session.setDefault 'artifactFilename', ''

reactiveStamper = new ReactiveVar(new timestamper.Timestamper())

imageT1 = new ReactiveVar '/img/empty-check.svg'
imageT2 = new ReactiveVar '/img/empty-check.svg'
imageT3 = new ReactiveVar '/img/empty-check.svg'

Template.Timestamp.events {

    'submit #artifact-form': (e) ->
        NProgress.configure({parent: "#timestamp-progress-bar", showSpinner: false, minimum: 0.3})

        e.preventDefault()

        $('#timestamp-progress-bar').css 'display', 'block'

        # Init the progress bar nprogress
        NProgress.start()

        form = e.target
        hash = Session.get 'artifactHash'

        tsaUrls = $(form).find('input[name="tsa_server"]:checked')

        urls = []
        $.each tsaUrls, (name, value) ->
            urls[name] = value.value

        artifactFilename = Session.get 'artifactFilename'

        stamper = reactiveStamper.get()

        stamper.timestamp(hash, artifactFilename, urls).then((result)->
            NProgress.inc()
            NProgress.done()
            FileSaver.saveAs result.data, result.zipName

            Meteor._reload.reload()
        ).catch((error) ->
            Toast.error(error, '', {width: 800})
        )

    'click #step-dropzone': (e) ->
        imageT1.set '/img/check.svg'

    'click #step-servers': (e) ->
        dropzone = Dropzone.forElement('#original-artifact')

        $('#step-button :button').prop 'disabled', true if $('input[name="tsa_server"]:checked').length is 0
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass 'error'
        else
            imageT2.set '/img/check.svg'

    'click #step-button': (e) ->
        dropzone = Dropzone.forElement('#original-artifact')
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass('error')
        else
            imageT2.set '/img/check.svg'
            imageT3.set '/img/check.svg'
}

Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'

    imageStepT1: ->
        imageT1.get()
    imageStepT2: ->
        imageT2.get()
    imageStepT3: ->
        imageT3.get()
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->
    $('.tooltipped').tooltip({delay: 50})

    dropzone = Dropzone.forElement('#original-artifact')
    $('#timestamp-page-link').addClass 'active'

    do $('ul.tabs').tabs;
    do $('.indicator').remove;

    dropzone.on 'addedfile', (file) ->
        NProgress.configure({parent: "#dropzone-progress-bar", showSpinner: false, minimum: 0.3})

        if validator.dropzoneValid dropzone

            $('#original-artifact').addClass('error') isnt file.accepted
            $('#original-artifact').removeClass('error') is file.accepted

            $(".dz-progress").remove();
            $('#step-servers :input').prop 'disabled', false

            Session.set 'artifactHash', ''
            Session.set 'artifactFilename', ''

            stamper = reactiveStamper.get()
            $('#dropzone-progress-bar').css 'display', 'block'
            NProgress.start()
            stamper.generateHash(file).then((result) ->
                NProgress.inc()
                Session.set 'artifactHash', result
                Session.set 'artifactFilename', file.name
                NProgress.done()
                $('#step-button :button').prop 'disabled', false
                $('#dropzone-progress-bar').css 'display', 'none'
            ).catch((error) ->
                Session.set 'artifactHash', 'NONE'

                $('#original-artifact').addClass 'error'
                $('#step-servers :input').prop 'disabled', true
                $('#step-button :button').prop 'disabled', true
            )
        else
            $('#original-artifact').addClass 'error'
            $('#step-servers :input').prop 'disabled', true
            $('#step-button :button').prop 'disabled', true

    dropzone.on 'removedfile', (file) ->
        if validator.dropzoneValid dropzone
            $('#step-button :button').prop 'disabled', false
            $('#step-servers :input').prop 'disabled', false
            $('#original-artifact').removeClass 'error'
        else
            $('#original-artifact').addClass 'error'
            $('#timestamp-progress-bar').css 'display', 'none'

            $('#step-servers :input').prop 'disabled', true
            $('#step-button :button').prop 'disabled', true

            imageT2.set('/img/empty-check.svg')
            imageT3.set('/img/empty-check.svg')

Template.Timestamp.onDestroyed ->
    $('#timestamp-page-link').removeClass 'active'
