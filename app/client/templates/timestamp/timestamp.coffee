FileSaver = require 'browser-filesaver'
timestamper = require '../../lib/timestamper'


Session.setDefault 'artifactHash', 'NONE'
Session.setDefault 'artifactFilename', ''

reactiveStamper = new ReactiveVar(new timestamper.Timestamper())


Template.Timestamp.events {
    'submit #artifact-form': (e) ->
        e.preventDefault()

        form = e.target
        hash = $(form).find('input[name="hash"]').val()
        artifactFilename = Session.get 'artifactFilename'

        isBusy.set true

        stamper = reactiveStamper.get()
        stamper.timestamp(hash, artifactFilename).then((result)->
            isBusy.set false
            FileSaver.saveAs result.data, result.zipName
        ).catch((error) ->
            isBusy.set false
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
    Dropzone.forElement('#original-artifact').on 'addedfile', (file)->
        Session.set 'artifactHash', ''
        Session.set 'artifactFilename', ''

        isBusy.set true

        stamper = reactiveStamper.get()
        stamper.generateHash(file).then((result) ->
            Session.set 'artifactHash', result
            Session.set 'artifactFilename', file.name

            isBusy.set false
        ).catch((error) ->
            Session.set 'artifactHash', 'NONE'
            console.log error

            isBusy.set false
        )


Template.Timestamp.onDestroyed ->
