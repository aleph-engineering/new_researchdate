Session.setDefault 'artifactHash', 'NONE'

Template.Timestamp.events {
  'change input[type="file"]': (e) ->
    Session.set 'artifactHash', ''

    files = $(e.target).get(0).files
    if files.length == 0
      Session.set 'artifactHash', 'NONE'
    else
      isBusy.set true
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
          isBusy.set false
      })
}

Template.Timestamp.helpers {
  artifactHash: ->
    Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->

Template.Timestamp.onDestroyed ->
