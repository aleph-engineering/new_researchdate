rfc5280 = require 'asn1.js/rfc/5280'
tsResponse = require './asn1/timestamp_response'


class TSRWrapper
    constructor: (responseBuffer) ->
        throw new TypeError 'responseBuffer was not provided, please provide one' unless responseBuffer
        @response = tsResponse.TimestampResponseTST.decode responseBuffer, 'der'
        if @_hasResponseStatus @response
            responseWithoutTST = tsResponse.TimestampResponse.decode responseBuffer, 'der'
            @encapsulatedContent = @_getEncapsulatedContent responseWithoutTST


#   PUBLIC METHODS
    getHashHex: =>
        content = @_getEncapsulatedContent @response
        hashBuffer = new Buffer content.messageImprint.hashedMessage
        hashBuffer.toString 'hex'


    getSignature: =>
        signerInfo = @_getSignerInfo @response
        signerInfo.signature


    getPublicKey: =>
        signerDetails = @_getSignerIssuerAndSerialNumber @response
        cert = @_getIssuerCertificate(
            @_getTimestampToken(@response).certificates
            signerDetails.issuer
            signerDetails.serialNumber
        )
        return null unless cert
        publicKeyInfo = cert.value.tbsCertificate.subjectPublicKeyInfo
        rfc5280.SubjectPublicKeyInfo.encode publicKeyInfo, 'pem', label: 'PUBLIC KEY'


    getSignedContent: =>
        return @encapsulatedContent unless @_ensureResponseHasSignedAttrs @response
        signerInfo = @_getSignerInfo @response
        tsResponse.SignedAttributes.encode signerInfo.signedAttrs, 'der'


# PRIVATE METHODS
    _ensureResponseIsDefined: (response) =>
        throw new Error('Missing response argument, please provide one') unless response


    _ensureResponseHasSignerInfo: (response) =>
        token = @_getTimestampToken response
        throw new TypeError('Does not contain a valid Signer Info') unless token.signerInfos.length is 1


    _getEncapsulatedContent: (response) =>
        @_ensureResponseIsDefined response
        @_getTimestampToken(response).encapContentInfo.eContent


    _getSignerInfo: (response) =>
        @_ensureResponseIsDefined response
        @_ensureResponseHasSignerInfo response
        token = @_getTimestampToken response
        token.signerInfos[0]


    _getSignerIssuerAndSerialNumber: (response) =>
        @_ensureResponseIsDefined response
        signerInfo = @_getSignerInfo response
        value = signerInfo.sid.value
        issuer: value.issuer, serialNumber: value.serialNumber


    _getIssuerCertificate: (certificates, issuer, serialNumber) =>
        throw new Error('certificates were not provided') unless certificates
        throw new Error('issuer was not provided') unless issuer
        throw new Error('serialNumber was not provided') unless serialNumber
        for cert in certificates
            tbs = cert.value.tbsCertificate
            return cert if _.isEqual(issuer, tbs.issuer) and _.isEqual(serialNumber, tbs.serialNumber)
        null


    _getTimestampToken: (response) =>
        throw new Error('response was not provided') unless response
        throw new Error('response has no proper status') unless @_hasResponseStatus response
        response.timeStampToken.content


    _ensureResponseHasSignedAttrs: (response) =>
        signerInfo = @_getSignerInfo response
        signerInfo.signedAttrs? and _.any(signerInfo.signedAttrs)


    _hasResponseStatus: (response) =>
        response? and (@_responseStatusIsGranted(response) or @_responseStatusIsGrantedWithMods(response))


    _responseStatusIsGranted: (response) =>
        response?.status?.status is 'granted'


    _responseStatusIsGrantedWithMods: (response) =>
        response?.status?.status is 'grantedWithMods'


#   PRIVATE METHODS
#    _assertResponseStatus = (response) ->
#        throw new TypeError('Does not contain a timestamp') unless _hasResponseStatus response

    #   There must be ONE AND ONLY ONE SignerInfo in the response, otherwise is not valid according to the standard
#    _assertSignerInfo = (response) ->
#        token = _getTimestampToken response
#        throw new TypeError('Does not contain a valid Signer Info') unless token.signerInfos.length is 1
#
#    _hasResponseStatus = (response) ->
#        responseStatus = (_responseStatusIsGranted(response) || _responseStatusIsGrantedWithMods(response))
#        response and responseStatus

#    _responseStatusIsGranted = (response) ->
#        response.status.status is 'granted'
#
#    _responseStatusIsGrantedWithMods = (response) ->
#        response.status.status is 'grantedWithMods'

#    _getTimestampToken = (response) ->
#        _assertResponseStatus response
#        response.timeStampToken.content

#    _getSignerInfo = (response) ->
#        _assertSignerInfo response
#        token = _getTimestampToken response
#        token.signerInfos[0]

#    _getSignerIssuerAndSerialNumber = (response) ->
#        signerInfo = _getSignerInfo response
#        {
#        issuer: signerInfo.sid.value.issuer,
#        serialNumber: signerInfo.sid.value.serialNumber
#        }

#    _getEncapsulatedContent = (response) ->
#        _getTimestampToken(response).encapContentInfo.eContent

#    _ensureResponseHasSignedAttrs = (response) ->
#        signerInfo = _getSignerInfo response
#        signerInfo.signedAttrs && signerInfo.signedAttrs.length > 0

#    _getIssuerCertificate = (certificates, issuer, serialNumber) ->
#        result = null
#        for cert in certificates
#            tbs = cert.value.tbsCertificate
#            if _.isEqual(issuer, tbs.issuer) && _.isEqual(serialNumber, tbs.serialNumber)
#                result = cert
#                break
#        return result


tsr = exports

tsr.TSRWrapper = TSRWrapper
tsr.getTSRWrapper = (responseBuffer) -> new TSRWrapper responseBuffer
