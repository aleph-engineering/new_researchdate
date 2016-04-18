digest = require '../../lib/digest_generator'

Session.setDefault 'artifactHash', 'NONE'


Template.Timestamp.events {
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
        if file?
            isBusy.set true
            digest.generateDigest file, (error, result) ->
                if error
#                    TODO (Marian Morgalo): Show a message to the user if an error occurs
                    console.log error
                else
                    Session.set 'artifactHash', result
                    isBusy.set false
        else
            Session.set 'artifactHash', 'NONE'


Template.Timestamp.onDestroyed ->
