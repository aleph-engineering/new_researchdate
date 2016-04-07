rfc5280 = require 'asn1.js/rfc/5280'
tsResponse = require './asn1/timestamp_response'


class TSRWrapper
    constructor: (@response) ->

#   PUBLIC METHODS
    getHashHex: () ->
        @_assertResponseStatus()
        content = @_getEncapsulatedContent()
        hashBuffer = new Buffer content.messageImprint.hashedMessage
        return hashBuffer.toString 'hex'

    getCertificatesDetails: () ->
        @_assertResponseStatus()
        certArray = []
        timestampToken = @_getTimestampToken()
        respCerts = timestampToken.certificates
        for cert in respCerts
            signatureBuffer = new Buffer cert.value.signature.data
            publicKeyInfo = cert.value.tbsCertificate.subjectPublicKeyInfo
            publicKeyPEM = rfc5280.SubjectPublicKeyInfo.encode publicKeyInfo, 'pem', label: 'PUBLIC KEY'
            certArray.push
                signature: signatureBuffer,
                publicKey: publicKeyPEM
        return certArray

    getSignedContent: () ->
        @_assertResponseStatus()
        responseContent = @_getEncapsulatedContent()
        signedContentObj = tsResponse.EncapsulatedContent.encode responseContent, 'der'
        signedContent = new Buffer signedContentObj
        return signedContent

#   PRIVATE METHODS
    _assertResponseStatus: () ->
        throw 'Does not contain a timestamp' if not @_responseAndResponseStatus

    _responseAndResponseStatus: () ->
        responseStatus = (_responseStatusIsGranted() || _responseStatusIsGrantedWithMods())
        @response && responseStatus

    _responseStatusIsGranted: () ->
        @response.status.status is 'granted'

    _responseStatusIsGrantedWithMods: () ->
        @response.status.status is 'grantedWithMods'

    _getTimestampToken: () ->
        @response.timeStampToken.content

    _getEncapsulatedContent: () ->
        @_getTimestampToken().encapContentInfo.eContent


tsr = exports

tsr.TSRWrapper = TSRWrapper
