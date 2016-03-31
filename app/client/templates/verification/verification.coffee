Template.Verification.events {
  'submit #verify-form': (e) ->
    e.preventDefault()
    tsr = $(e.target).find('#tsr-hash-input').get(0).files
    console.log tsr[0]
    origin = $(e.target).find('#original-file-input').get(0).files
    Meteor.call 'server/verify', tsr[0], origin[0], (error, result) ->

}

Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

