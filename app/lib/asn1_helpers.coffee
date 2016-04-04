## ASN.1 structure for the timestamp request and response defined in RFC 3161

asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'

MessageImprint = asn.define 'MessageImprint', () ->
    @seq().obj(
        @key('hashAlgorithm').use(rfc5280.AlgorithmIdentifier)
        @key('hashedMessage').octstr()
    )

TimestampRequest = asn.define 'TimestampRequest', () ->
    @seq().obj(
        @key('version').int({
            1: 'v1'
        }),
        @key('messageImprint').use(MessageImprint),
        @key('reqPolicy').optional().objid(),
        @key('nonce').optional().int(),
        @key('certReq').def(false).bool(),
        @key('extensions').optional().implicit(0).seqof(rfc5280.Extension)
    )

TimestampResponse = asn.define 'TimestampResponse', () ->
    @seq().obj(
        @key('status').seq().obj(
            @key('status').int({
                0: 'granted',
                1: 'grantedWithMods',
                2: 'rejection',
                3: 'waiting',
                4: 'revocationWarning',
                5: 'revocationNotification'
            }),
            @key('statusString').optional().seq().obj(
                @key('text').optional().utf8str()
            ),
            @key('failInfo').optional().bitstr({
                '0': 'badAlg',
                '2': 'badRequest',
                '5': 'badDataFormat',
                '14': 'timeNotAvailable',
                '15': 'unacceptedPolicy',
                '16': 'unacceptedExtension',
                '17': 'addInfoNotAvailable',
                '25': 'systemFailure'
            }),
        ),
        @key('timeStampToken').optional().seq().obj(
            @key('contentType').objid(),
            @key('content').explicit(0).any().use(TSTInfo)
        )
    )

TSTInfo = asn.define 'TSTInfo', () ->
    @seq().obj(
        @key('version').int({
            1: 'v1'
        }),
        @key('policy').objid(),
        @key('messageImprint').use(MessageImprint),
        @key('serialNumber').int(),
        @key('genTime').gentime(),
        @key('accuracy').optional().seq().obj(
            @key('seconds').optional().int(),
            @key('millis').optional().explicit(0).int(),
            @key('micros').optional().explicit(1).int()
        ),
        @key('ordering').def(false).bool(),
        @key('nonce').optional().int(),
        @key('tsa').optional().explicit(0).use(rfc5280.GeneralName),
        @key('extensions').optional().implicit(1).seqof(rfc5280.Extension)
    )


@generateTimestampRequest = (hash) ->
    hashBuffer = new Buffer hash, 'hex'
    output = TimestampRequest.encode({
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
