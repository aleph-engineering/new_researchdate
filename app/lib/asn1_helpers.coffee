## ASN.1 structure for the timestamp request and response defined in RFC 3161
tsRequest = require './asn1/timestamp_request'
tsReponse = require './asn1/timestamp_response'


@generateTimestampRequest = (hash) ->
    hashBuffer = new Buffer hash, 'hex'
    output = tsRequest.TimestampRequest.encode({
        version: 1,
        messageImprint: {
            hashAlgorithm: {
                algorithm: HASHES.sha256.oid.split('.')
            },
            hashedMessage: hashBuffer
        },
        certReq: true
    }, 'der')
    return output

@parseTimestampResponse = (responseBuffer) ->
    response = tsReponse.TimestampResponse.decode responseBuffer, 'der'
    return response

@getHashFromResponse = (response) ->
    return fillHashBufferAndConvert response if responseAndResponseStatus response
    null

responseStatusIsGranted = (response) ->
    return response.status.status is 'granted'
    false

responseStatusIsGrantedWithMods = (response) ->
    return response.status.status is 'grantedWithMods'
    false

fillHashBufferAndConvert = (response) ->
    timeStampTokenContent = response.timeStampToken.content
    eContent = timeStampTokenContent.encapContentInfo.eContent
    hashBuffer = new Buffer(eContent.messageImprint.hashedMessage)
    hashBuffer.toString 'hex'

responseAndResponseStatus = (response) ->
    responseStatus = (responseStatusIsGranted response || responseStatusIsGrantedWithMods response)
    return response && responseStatus
    false
