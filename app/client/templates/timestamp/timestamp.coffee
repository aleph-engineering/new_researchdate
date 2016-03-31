STREAMING_CHUNK_SIZE = 1024 * 1024 #1 Mb
createHash = require 'sha.js'


Session.setDefault 'artifactHash', 'NONE'

Template.Timestamp.events {
    'change input[type="file"]': (e) ->
        Session.set 'artifactHash', ''

        files = $(e.target).get(0).files
        if files.length == 0
            Session.set 'artifactHash', 'NONE'
        else
            isBusy.set true
            sha256 = createHash('sha256')
            file = files[0]
            parseFile(file, {
                binary: true,
                chunk_size: STREAMING_CHUNK_SIZE,
                chunk_read_callback: (chunk) ->
                    chunkBuffer = new Buffer(chunk)
                    sha256.update chunkBuffer
                success: ->
                    hash = sha256.digest('hex')
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
