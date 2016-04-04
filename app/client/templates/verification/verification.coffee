jsSHA = require 'jssha'

hashGenerate = @hashGenerate

Template.Verification.events {
    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $(e.target).find('#tsr-hash-input').get(0).files
        file = $(e.target).find('#original-file-input').get(0).files
        console.log file
        #        for_now = $(e.target).find('#result-input')
        #        for_now[0].value = 'Verification True'
        generateDigest file[0], (error, result) ->
            if error
                console.log error
            else
                console.log result
#          TODO (Helen Garcia Gonzalez): Write code here for call method 'server/verify'
#        Meteor.call 'server/verify', tsr[0], origin[0], (error, result) ->

}

Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

