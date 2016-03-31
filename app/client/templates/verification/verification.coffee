Template.Verification.events {
  'submit #verify-form': (e) ->
    e.preventDefault()
    Meteor.call 'server/verify', 909, 123, (error, result) ->
#      console.log 'regreso'

}

Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

