FileSaver = require 'browser-filesaver'
timestamper = require '../../lib/timestamper'
validator = require '../../lib/validator'

Session.setDefault 'artifactHash', 'NONE'
Session.setDefault 'artifactFilename', ''

reactiveStamper = new ReactiveVar(new timestamper.Timestamper())

Template.Timestamp.events {

    'submit #artifact-form': (e) ->
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
        ).catch((error) ->
            Toast.error(error, '', {width: 800})
        )

    'click #step-number': (e) ->
        $('#step-number .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

    'click #step-servers': (e) ->
        dropzone = Dropzone.forElement('#original-artifact')

        $('#step-button :button').prop 'disabled', true if $('input[name="tsa_server"]:checked').length is 0
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass 'error'
        else
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    'click #step-button': (e) ->
        dropzone = Dropzone.forElement('#original-artifact')
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass('error')
        else
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

            $('#step-button .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'
}

Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'
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
        $('#step-servers :input').prop 'disabled', false
        $('#step-button :button').prop 'disabled', false

        $('#original-artifact').removeClass('error')
        Session.set 'artifactHash', ''
        Session.set 'artifactFilename', ''

        stamper = reactiveStamper.get()
        stamper.generateHash(file).then((result) ->
            Session.set 'artifactHash', result
            Session.set 'artifactFilename', file.name
        ).catch((error) ->
            Session.set 'artifactHash', 'NONE'

            $('#original-artifact').addClass 'error'
            $('#step-servers :input').prop 'disabled', true
            $('#step-button :button').prop 'disabled', true
        )

    dropzone.on 'removedfile', (file) ->
        do disablingSteps

Template.Timestamp.onDestroyed ->
    $('#timestamp-page-link').removeClass 'active'

disablingSteps = ->
    $('#original-artifact').addClass 'error'
    $('#timestamp-progress-bar').css 'display', 'none'

    $('#step-servers :input').prop 'disabled', true
    $('#step-button :button').prop 'disabled', true

    $('#step-servers .materialboxed').attr 'src', (index, attr) ->
        attr.replace '/img/check.svg', '/img/empty-check.svg'

    $('#step-button .materialboxed').attr 'src', (index, attr) ->
        attr.replace '/img/check.svg', '/img/empty-check.svg'
