tsr_helpers = require './tsr_helpers'
crypto = require 'crypto'


verifyTimestamp = (artifactHash, responseBuffer)->
    responseWrapper = new tsr_helpers.TSRWrapper responseBuffer

    #   First we compare the artifact hash and the hash contained in the response
    tsrHash = responseWrapper.getHashHex()
    return false unless artifactHash == tsrHash

    #   Then we verify that the response's content was signed with the certificate also present in it
    signedContentBuffer = responseWrapper.getSignedContent()
    signature = responseWrapper.getSignature()
    publicKey = responseWrapper.getPublicKey()

    verify = crypto.createVerify 'RSA-SHA1'
    verify.update signedContentBuffer
    return verify.verify publicKey, signature


exports.verifyTimestamp = verifyTimestamp
