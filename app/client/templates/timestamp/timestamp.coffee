if Meteor.isClient
  Session.setDefault 'artifactHash', 'NONE'

Template.timestamp.events {
  'change input[type="file"]': (e) ->
    Session.set 'artifactHash', ''

    files = $(e.target).get(0).files
    if files.length == 0
      Session.set 'artifactHash', 'NONE'
    else
      shaObj = new jsSHA('SHA-256', 'BYTES')
      file = files[0]
      parseFile(file, {
        binary: true
        chunk_read_callback: (chunk) ->
          bytesString = String.fromCharCode.apply(null, new Uint8Array(chunk));
          shaObj.update bytesString
        success: ->
#TODO (Marian Morgalo) Show spinner while is generating the hash (for large files, it may take a while)
          hash = shaObj.getHash('HEX')
          console.log 'HASH: ' + hash
          Session.set 'artifactHash', hash
      })
}

Template.timestamp.helpers {
  artifactHash: ->
    Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.timestamp.onCreated ->

Template.timestamp.onRendered ->

Template.timestamp.onDestroyed ->
