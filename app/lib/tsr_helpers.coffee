rfc5280 = require 'asn1.js/rfc/5280'
tsResponse = require './asn1/timestamp_response'


class TSRWrapper
    constructor: (responseBuffer) ->
        unless responseBuffer
            throw new TypeError 'responseBuffer was not provided, please provide one'
        @response = tsResponse.TimestampResponseTST.decode responseBuffer, 'der'
        if _hasResponseAndResponseHasStatus @response
            responseWithoutTST = tsResponse.TimestampResponse.decode responseBuffer, 'der'
            @encapsulatedContent = _getEncapsulatedContent responseWithoutTST

#   PUBLIC METHODS
    getHashHex: () ->
        content = _getEncapsulatedContent @response
        hashBuffer = new Buffer content.messageImprint.hashedMessage
        return hashBuffer.toString 'hex'

    getSignature: () ->
        signerInfo = _getSignerInfo @response
        signerInfo.signature

    getPublicKey: () ->
        pem = null
        signerDetails = _getSignerIssuerAndSerialNumber @response
        cert = _getIssuerCertificate _getTimestampToken(@response).certificates, signerDetails.issuer, signerDetails.serialNumber
        if cert
            publicKeyInfo = cert.value.tbsCertificate.subjectPublicKeyInfo
            pem = rfc5280.SubjectPublicKeyInfo.encode publicKeyInfo, 'pem', label: 'PUBLIC KEY'
        return pem

    getSignedContent: () ->
        signedContent = null
        if not _responseHasSignedAttrs @response
            signedContent = @encapsulatedContent
        else
            signerInfo = _getSignerInfo @response
            signedContent = tsResponse.SignedAttributes.encode signerInfo.signedAttrs, 'der'


    #   PRIVATE METHODS
    _assertResponseStatus = (response) ->
        throw 'Does not contain a timestamp' if not _hasResponseAndResponseHasStatus response

    #   There must be ONE AND ONLY ONE SignerInfo in the response, otherwise is not valid according to the standard
    _assertSignerInfo = (response) ->
        token = _getTimestampToken response
        throw 'Does not contain a valid Signer Info' if not token.signerInfos.length == 1

    _hasResponseAndResponseHasStatus = (response) ->
        responseStatus = (_responseStatusIsGranted(response) || _responseStatusIsGrantedWithMods(response))
        response and responseStatus

    _responseStatusIsGranted = (response) ->
        response.status.status is 'granted'

    _responseStatusIsGrantedWithMods = (response) ->
        response.status.status is 'grantedWithMods'

    _getTimestampToken = (response) ->
        _assertResponseStatus response
        response.timeStampToken.content

    _getSignerInfo = (response) ->
        _assertSignerInfo response
        token = _getTimestampToken response
        token.signerInfos[0]

    _getSignerIssuerAndSerialNumber = (response) ->
        signerInfo = _getSignerInfo response
        {
        issuer: signerInfo.sid.value.issuer,
        serialNumber: signerInfo.sid.value.serialNumber
        }

    _getEncapsulatedContent = (response) ->
        _getTimestampToken(response).encapContentInfo.eContent

    _responseHasSignedAttrs = (response) ->
        signerInfo = _getSignerInfo response
        signerInfo.signedAttrs && signerInfo.signedAttrs.length > 0

    _getIssuerCertificate = (certificates, issuer, serialNumber) ->
        result = null
        for cert in certificates
            tbs = cert.value.tbsCertificate
            if _.isEqual(issuer, tbs.issuer) && _.isEqual(serialNumber, tbs.serialNumber)
                result = cert
                break
        return result


tsr = exports

tsr.TSRWrapper = TSRWrapper
tsr.getTSRWrapper = (responseBuffer) -> new TSRWrapper responseBuffer
