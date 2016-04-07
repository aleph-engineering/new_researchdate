STREAMING_CHUNK_SIZE = 1024 * 1024 #1 Mb


generateDigest = (file, callback) ->
    createHash = require 'sha.js'
    sha256 = createHash 'sha256'
    parseFile file,
        binary: true,
        chunk_size: STREAMING_CHUNK_SIZE,
        chunk_read_callback: (chunk) ->
            chunkBuffer = new Buffer chunk
            sha256.update chunkBuffer
        error_callback: (error) ->
            callback(error, null) if callback?
        success: ->
            if callback?
                digest = sha256.digest 'hex'
                callback null, digest


exports.generateDigest = generateDigest
