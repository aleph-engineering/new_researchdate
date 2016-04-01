jsSHA = require 'jssha'

Session.setDefault 'artifactHash', 'NONE'

Template.Timestamp.events {
    'change input[type="file"]': (e) ->
        Session.set 'artifactHash', ''

        files = $(e.target).get(0).files
        if files.length == 0
            Session.set 'artifactHash', 'NONE'
        else
            isBusy.set true
            file = files[0]
            hashGenerate(file)
            generateDigest file, (error, result) ->
                if error
#                    TODO (Marian Morgalo): Show a message to the user if an error occurs
                    console.log error
                else
                    Session.set 'artifactHash', result
                    isBusy.set false
}

Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->

Template.Timestamp.onDestroyed ->
