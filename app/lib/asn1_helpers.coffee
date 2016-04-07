## ASN.1 structure for the timestamp request and response defined in RFC 3161

@generateTimestampRequest = (hash) ->
    tsRequest = require './asn1/timestamp_request'
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
    tsReponse = require './asn1/timestamp_response'
    response = tsReponse.TimestampResponse.decode responseBuffer, 'der'
    return response

@getHashFromResponse = (response) ->
    hash = null
    if response && (response.status.status == 'granted' || response.status.status == 'grantedWithMods')
        hashBuffer = new Buffer(response.timeStampToken.content.encapContentInfo.eContent.messageImprint.hashedMessage)
        hash = hashBuffer.toString 'hex'
    return hash
