asn1_helpers = require './asn1_helpers'
tsr_helpers = require './tsr_helpers'
crypto = require 'crypto'


verifyTimestamp = (artifactHash, responseBuffer)->
    asn1_helpers.parseTimestampResponse responseBuffer

    #   First we compare the artifact hash and the hash contained in the response
    tsrHash = response.getHashHex()
    return false unless artifactHash == tsrHash

    #   Then we verify that the response's content was signed with the certificates also present in it
    signedContentBuffer = response.getSignedContent()
    certsInfo = response.getCertificatesDetails()
    for cert in certsInfo
        verify = crypto.createVerify 'RSA-SHA512'
        verify.update signedContentBuffer
        return false unless verify.verify cert.publicKey, cert.signature

    true


exports.verifyTimestamp = verifyTimestamp
