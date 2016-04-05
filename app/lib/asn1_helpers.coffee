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
    hash = null
    if response && (response.status.status == 'granted' || response.status.status == 'grantedWithMods')
        hashBuffer = new Buffer(response.timeStampToken.content.encapContentInfo.eContent.messageImprint.hashedMessage)
        hash = hashBuffer.toString 'hex'
    return hash
