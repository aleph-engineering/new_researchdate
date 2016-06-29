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

#            Meteor._reload.reload()
        ).catch((error) ->
            Toast.error(error, '', {width: 800})
        )

    'click #googledrive-button': (e) ->
        googleUser = Meteor.users.findOne()

        drv = "drive/v2/files/"
        #        folder =  drv + "0Bx3dTZ_Sau1gaENic0FZcGJKdDA"

        #        GoogleApi.get(folder + '/children', user: googleUser).then((result)->

        body =
            'mimeType': 'TEST.txt'
            'title': 'test'
        #            'parents': [ { 'id': '0Bx3dTZ_Sau1gaENic0FZcGJKdDA' } ]

        GoogleApi.post(drv,
            user: googleUser
            data: body).then((result)->

            Toast.info('Successful', '', {width: 800})
        ).catch((error) ->
            Toast.error(error, '', {width: 800})
        )

#            for item in result.items
#                GoogleApi.get(drv + item.id, user: googleUser).then((result)->
#                    console.log result.title
#                ).catch((error) ->
#                    console.log error
#                )
#
#        ).catch((error) ->
#            console.log error
#        )

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
        $(".dz-progress").remove();
        $('#step-servers :input').prop 'disabled', false

        $('#original-artifact').removeClass('error')
        Session.set 'artifactHash', ''
        Session.set 'artifactFilename', ''

        stamper = reactiveStamper.get()
        stamper.generateHash(file).then((result) ->
            Session.set 'artifactHash', result
            Session.set 'artifactFilename', file.name
            $('#step-button :button').prop 'disabled', false
        ).catch((error) ->
            Session.set 'artifactHash', 'NONE'

            $('#original-artifact').addClass 'error'
            $('#step-servers :input').prop 'disabled', true
            $('#step-button :button').prop 'disabled', true
        )

    dropzone.on 'removedfile', (file) ->
        $('#original-artifact').addClass 'error'
        $('#timestamp-progress-bar').css 'display', 'none'

        $('#step-servers :input').prop 'disabled', true
        $('#step-button :button').prop 'disabled', true

        imageT2.set('/img/empty-check.svg')
        imageT3.set('/img/empty-check.svg')

Template.Timestamp.onDestroyed ->
    $('#timestamp-page-link').removeClass 'active'
