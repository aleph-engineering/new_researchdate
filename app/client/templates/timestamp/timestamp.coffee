digest = require '../../lib/digest_generator'

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
            digest.generateDigest file, (error, result) ->
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
    $('#original-artifact').on 'success', ()->
        console.log 'aaa'

#    Meteor.Dropzone.options.init = () ->
#        r = Dropzone.getElement("#original-artifact").dropzone
#        console.log r
#        @on 'dragstart', (e)->
#            console.log 'ok'


Template.Timestamp.onDestroyed ->
