FileSaver = require 'browser-filesaver'
timestamper = require '../../lib/timestamper'
validator = require '../../lib/validator'


Session.setDefault 'artifactHash', 'NONE'
Session.setDefault 'artifactFilename', ''

reactiveStamper = new ReactiveVar(new timestamper.Timestamper())

Template.Timestamp.events {
    'submit #artifact-form': (e) ->
        e.preventDefault()

        form = e.target
        hash = Session.get 'artifactHash'
        tsaUrl = $(form).find('input[name="tsa_server"]:checked').val()
        artifactFilename = Session.get 'artifactFilename'
        save = $(form).find('input[name="save"]').val()

        stamper = reactiveStamper.get()
        stamper.timestamp(hash, artifactFilename, tsaUrl, save).then((result)->
            NProgress.inc()
            NProgress.done()
            FileSaver.saveAs result.data, result.zipName
        ).catch((error) ->
            if (error)
                Toast.error(error, '', {width: 800})
            else
                $('#original-artifact').addClass('error')
        )

}

Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->
    dropzone = Dropzone.forElement('#original-artifact')

    $('#timestamp-button').on 'click', ->
        $('#timestamp-progress-bar').css("display", "block")

        # Init the progress bar 'nprogress
        NProgress.start()

    $('#step-number').on 'click', ->
        $('#step-number .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#step-servers').on 'click', ->
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass('error')
        else
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'


    $('#step-button').on 'click', ->
        if validator.dropzoneEmpty(dropzone)
            $('#original-artifact').addClass('error')
        else
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

            $('#step-button .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#timestamp-page-link').addClass 'active'

    do $('ul.tabs').tabs;
    do $('.indicator').remove;

    dropzone.on 'addedfile', (file)->
        $('#step-servers :input').prop('disabled', false)
        $('#step-button :button').prop('disabled', false)

        $('#original-artifact').removeClass('error')
        Session.set 'artifactHash', ''
        Session.set 'artifactFilename', ''

        stamper = reactiveStamper.get()
        stamper.generateHash(file).then((result) ->
            Session.set 'artifactHash', result
            Session.set 'artifactFilename', file.name
        ).catch((error) ->
            Session.set 'artifactHash', 'NONE'
            console.log error
        )

    dropzone.on 'removedfile', (file)->
        $('#original-artifact').addClass('error')
        $('#timestamp-progress-bar').css("display", "none")

        $('#step-servers :input').prop('disabled', true)
        $('#step-button :button').prop('disabled', true)

        $('#step-servers .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/check.svg', '/img/empty-check.svg'

        $('#step-button .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/check.svg', '/img/empty-check.svg'

Template.Timestamp.onDestroyed ->
    $('#timestamp-page-link').removeClass 'active'





