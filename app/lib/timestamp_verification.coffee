tsr_helpers = require './tsr_helpers'
rsaSign = require('jsrsasign');


verifyTimestamp = (artifactHash, responseBuffer)->
    responseWrapper = new tsr_helpers.TSRWrapper responseBuffer

    #   First we compare the artifact hash and the hash contained in the response
    tsrHash = responseWrapper.getHashHex()
    return false unless artifactHash == tsrHash

    #   Then we verify that the response's content was signed with the certificate also present in it
    signedContentBuffer = responseWrapper.getSignedContent()
    signature = responseWrapper.getSignature()
    publicKey = responseWrapper.getPublicKey()

    sig = new rsaSign.Signature({"alg": "SHA1withRSA"});
    sig.init publicKey
    sig.updateHex signedContentBuffer.toString('hex')
    return sig.verify signature.toString('hex')


exports.verifyTimestamp = verifyTimestamp
