STREAMING_CHUNK_SIZE = 1024 * 1024 #1 Mb
createHash = require 'sha.js'


@generateDigest = (file, callback) ->
    sha256 = createHash 'sha256'

    setTimeout (-> callback(null, 'aaa')), 500

#    _generateDigest = ->
#        parseFile file,
#            binary: true,
#            chunk_size: STREAMING_CHUNK_SIZE,
#            chunk_read_callback: (chunk) ->
#                chunkBuffer = new Buffer chunk
#                sha256.update chunkBuffer
#            error_callback: (error) ->
#                callback(error, null) if callback?
#            success: ->
#                if callback?
#                    digest = sha256.digest 'hex'
#                    callback null, digest
#
#    setTimeout _generateDigest, 0
