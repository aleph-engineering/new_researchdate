if Meteor.isClient
  Session.setDefault 'artifactHash', 'None'


Template.Home.events {
  'change input[type="file"]': (e) ->
    files = $(e.target).get(0).files
    if files == 0
      Session.set 'artifactHash', 'None'
    else
      shaObj = new jsSHA('SHA-256', 'BYTES')
      file = files[0]
      parseFile(file, {
        binary: true
        chunk_read_callback: (chunk) ->
          bytesString = String.fromCharCode.apply(null, new Uint8Array(chunk));
          shaObj.update bytesString
        success: ->
          hash = shaObj.getHash('HEX')
          console.log 'HASH: ' + hash
          Session.set 'artifactHash', hash
      })
}

Template.Home.helpers {
  artifactHash: ->
    Session.get 'artifactHash'
}

# Home: Lifecycle Hooks
Template.Home.onCreated ->

Template.Home.onRendered ->

Template.Home.onDestroyed ->
