jsSHA = require 'jssha'

@hashGenerate = (file, callback) ->
    shaObj = new jsSHA('SHA-256', 'BYTES')
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
            callback()
    })

