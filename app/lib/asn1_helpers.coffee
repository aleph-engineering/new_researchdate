## ASN.1 structure for the timestamp request and response defined in RFC 3161
tsRequest = require './asn1/timestamp_request'
tsResponse = require './asn1/timestamp_response'
hashes = require './asn1/hash_helpers'
tsr_helpers = require './tsr_helpers'


class TimestampRequestGenerator

    constructor: (@hash) ->


    _generateBufferFromHash: (hash) =>
        new Buffer hash, 'hex'


    generate: =>
        hashBuffer = @_generateBufferFromHash @hash
        tsRequest.TimestampRequest.encode(
            version: 1
            messageImprint:
                hashAlgorithm:
                    algorithm: hashes.HASHES.sha256.oid.split '.'
                hashedMessage: hashBuffer
            certReq: true
        , 'der')


asn1_helpers = exports

asn1_helpers.TimestampRequestGenerator = TimestampRequestGenerator
asn1_helpers.getTimestampRequestGenerator = (hash) -> new TimestampRequestGenerator hash
