createHash = require 'sha.js'


generateDigestWithStream = (stream, callback) ->
    sha256 = createHash 'sha256'

    stream.on 'data', (chunk) ->
        sha256.update chunk

    stream.on 'end', () ->
        if callback?
            digest = sha256.digest 'hex'
            callback null, digest

    stream.on 'error', (error) ->
        callback(error, null) if callback?


exports.generateDigestWithStream = generateDigestWithStream
