FileSaver = require 'browser-filesaver'
timestamper = require '../../lib/timestamper'


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
        #        isBusy.set true

        stamper = reactiveStamper.get()
        stamper.timestamp(hash, artifactFilename, tsaUrl, save).then((result)->
#            isBusy.set false
            NProgress.inc()
            NProgress.done()
            FileSaver.saveAs result.data, result.zipName
        ).catch((error) ->
#            isBusy.set false
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
    $('#timestamp-button').on 'click', ->
        $('#timestamp-progress-bar').css("display", "block")

        # Init the progress bar 'nprogress
        NProgress.start()

    $('#step-number').on 'click', ->
        $('#step-number .materialboxed').attr 'src', (index, attr) ->
            attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#step-servers').on 'click', ->
        if Dropzone.forElement('#original-artifact').files.length != 0
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#step-button').on 'click', ->
        if Dropzone.forElement('#original-artifact').files.length != 0
            $('#step-servers .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

            $('#step-button .materialboxed').attr 'src', (index, attr) ->
                attr.replace '/img/empty-check.svg', '/img/check.svg'

    $('#timestamp-page-link').addClass 'active'

    do $('ul.tabs').tabs;
    do $('.indicator').remove;

    Dropzone.forElement('#original-artifact').on 'addedfile', (file)->
        $('#step-servers :input').prop('disabled', false)
        $('#step-button :button').prop('disabled', false)

        $('#original-artifact').removeClass('error')
        Session.set 'artifactHash', ''
        Session.set 'artifactFilename', ''

        #        isBusy.set true
        stamper = reactiveStamper.get()
        stamper.generateHash(file).then((result) ->
            Session.set 'artifactHash', result
            Session.set 'artifactFilename', file.name

#            isBusy.set false
        ).catch((error) ->
            Session.set 'artifactHash', 'NONE'
            console.log error

#            isBusy.set false
        )

    Dropzone.forElement('#original-artifact').on 'removedfile', (file)->
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
