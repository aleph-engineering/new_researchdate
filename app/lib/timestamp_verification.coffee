tsr_helpers = require './tsr_helpers'
rsaSign = require 'jsrsasign'


class TimestampVerifier

    constructor: (@artifactHash, @responseBuffer) ->


    _getSignature: (responseWrapper) =>
        new rsaSign.Signature "alg": responseWrapper.getHashAlgorithmForVerification()


    verify: =>
        responseWrapper = tsr_helpers.getTSRWrapper @responseBuffer

        #   First we compare the artifact hash and the hash contained in the response
        tsrHash = responseWrapper.getHashHex()
        return no unless @artifactHash is tsrHash

        #   Then we verify that the response's content was signed with the certificate also present in it
        signedContentBuffer = responseWrapper.getSignedContent()
        signature = responseWrapper.getSignature()
        publicKey = responseWrapper.getPublicKey()

        sig = @_getSignature responseWrapper
        sig.init publicKey
        sig.updateHex signedContentBuffer.toString 'hex'
        sig.verify signature.toString 'hex'


exports.TimestampVerifier = TimestampVerifier
