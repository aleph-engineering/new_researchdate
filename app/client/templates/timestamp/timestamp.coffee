digest = require '../../lib/digest_generator'
validator = require '../../lib/validator'

Session.setDefault 'artifactHash', 'NONE'


Template.Timestamp.events {
    'submit #artifact-form': (e) ->
        e.preventDefault()
        val = $('#hash').val()
        e.target.submit() if !validator.validArgsForTimestamp(val)
        $('#original-artifact').addClass('error') if validator.validArgsForTimestamp(val)
}


Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->
    Dropzone.forElement('#original-artifact').on 'addedfile', (file)->
        $('#original-artifact').removeClass('error')
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
