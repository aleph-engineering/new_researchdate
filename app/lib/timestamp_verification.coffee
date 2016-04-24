tsr_helpers = require './tsr_helpers'
rsaSign = require 'jsrsasign'
util = require 'util'


class TimestampVerifier

    constructor: (@artifactHash, @responseBuffer) ->


    _getSignature: =>
        new rsaSign.Signature "alg": "SHA1withRSA"


    verify: =>
        responseWrapper = tsr_helpers.getTSRWrapper @responseBuffer

        #   First we compare the artifact hash and the hash contained in the response
        tsrHash = responseWrapper.getHashHex()
        return no unless @artifactHash is tsrHash

        #   Then we verify that the response's content was signed with the certificate also present in it
        signedContentBuffer = responseWrapper.getSignedContent()
        signature = responseWrapper.getSignature()
        publicKey = responseWrapper.getPublicKey()

        sig = @_getSignature()
        sig.init publicKey
        sig.updateHex signedContentBuffer.toString 'hex'
        sig.verify signature.toString 'hex'


# TODO: (@riel) Replace calls to this method with "verify" method on the above class
verifyTimestamp = (artifactHash, responseBuffer) ->
    responseWrapper = tsr_helpers.getTSRWrapper responseBuffer

    #   First we compare the artifact hash and the hash contained in the response
    tsrHash = responseWrapper.getHashHex()
    return no unless artifactHash is tsrHash

    #   Then we verify that the response's content was signed with the certificate also present in it
    signedContentBuffer = responseWrapper.getSignedContent()
    signature = responseWrapper.getSignature()
    publicKey = responseWrapper.getPublicKey()

    sig = new rsaSign.Signature "alg": "SHA1withRSA"
    sig.init publicKey
    sig.updateHex signedContentBuffer.toString 'hex'
    sig.verify signature.toString 'hex'
util.deprecate(verifyTimestamp, 'should not be used use an instance of TimestampVerifier and call verify method')


exports.verifyTimestamp = verifyTimestamp
exports.TimestampVerifier = TimestampVerifier
