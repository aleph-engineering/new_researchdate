asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'
common = require './common'


TimestampResponse = asn.define 'TimestampResponse', () ->
    @seq().obj(
        @key('status').use PKIStatusInfo
        @key('timeStampToken').optional().seq().obj(
            @key('contentType').objid common.PKCS7_CONTENT_TYPES
            @key('content').optional().explicit(0).use SignedData
        )
    )


TimestampResponseTST = asn.define 'TimestampResponse', () ->
    @seq().obj(
        @key('status').use PKIStatusInfo
        @key('timeStampToken').optional().seq().obj(
            @key('contentType').objid common.PKCS7_CONTENT_TYPES
            @key('content').optional().explicit(0).use SignedDataTST
        )
    )


PKIStatusInfo = asn.define 'PKIStatusInfo', () ->
    @seq().obj(
        @key('status').int
            0: 'granted',
            1: 'grantedWithMods',
            2: 'rejection',
            3: 'waiting',
            4: 'revocationWarning',
            5: 'revocationNotification'
        @key('statusString').optional().seq().obj @key('text').optional().utf8str()
        @key('failInfo').optional().bitstr
            '0': 'badAlg',
            '2': 'badRequest',
            '5': 'badDataFormat',
            '14': 'timeNotAvailable',
            '15': 'unacceptedPolicy',
            '16': 'unacceptedExtension',
            '17': 'addInfoNotAvailable',
            '25': 'systemFailure'
    )


SignedData = asn.define 'SignedData', () ->
    @seq().obj(
        @key('version').use(CMSVersion),
        @key('digestAlgorithms').setof(rfc5280.AlgorithmIdentifier),
        @key('encapContentInfo').use(EncapsulatedContentInfo),
        @key('certificates').optional().implicit(0).setof(CertificateChoices),
        @key('crls').optional().implicit(1).setof(RevocationInfoChoice),
        @key('signerInfos').setof(SignerInfo)
    )


SignedDataTST = asn.define 'SignedData', () ->
    @seq().obj(
        @key('version').use(CMSVersion),
        @key('digestAlgorithms').setof(rfc5280.AlgorithmIdentifier),
        @key('encapContentInfo').use(EncapsulatedContentInfoTST),
        @key('certificates').optional().implicit(0).setof(CertificateChoices),
        @key('crls').optional().implicit(1).setof(RevocationInfoChoice),
        @key('signerInfos').setof(SignerInfo)
    )


EncapsulatedContentInfo = asn.define 'EncapsulatedContentInfo', () ->
    @seq().obj(
        @key('eContentType').objid(),
        @key('eContent').use(EncapsulatedContent)
    )


EncapsulatedContentInfoTST = asn.define 'EncapsulatedContentInfoTST', () ->
    @seq().obj(
        @key('eContentType').objid(),
        @key('eContent').use(EncapsulatedContentTST)
    )


EncapsulatedContent = asn.define 'EncapsulatedContent', () ->
    @optional().explicit(0).octstr()


EncapsulatedContentTST = asn.define 'EncapsulatedContentTST', () ->
    @optional().explicit(0).octstr().contains(TSTInfo)


TSTInfo = asn.define 'TSTInfo', () ->
    @seq().obj(
        @key('version').int({
            1: 'v1'
        }),
        @key('policy').objid(),
        @key('messageImprint').use(common.MessageImprint),
        @key('serialNumber').int(),
        @key('genTime').gentime(),
        @key('accuracy').optional().seq().obj(
            @key('seconds').optional().int(),
#            Commented because the library doesn't support the length of this integers right now
#            @key('millis').optional().explicit(0),
#            @key('micros').optional().explicit(1)
        ),
        @key('ordering').def(false).bool(),
        @key('nonce').optional().int(),
        @key('tsa').optional().explicit(0).use(rfc5280.GeneralName),
        @key('extensions').optional().implicit(1).seqof(rfc5280.Extension)
    )


CertificateChoices = asn.define 'CertificateChoices', () ->
    @choice({
        certificate: @use(rfc5280.Certificate),
        extendedCertificate: @implicit(0).use(rfc5280.Certificate),
        v1AttrCert: @implicit(1).use(rfc5280.Certificate),
        v2AttrCert: @implicit(2).use(rfc5280.Certificate),
        other: @implicit(3).seq().obj(
            @key('otherCertFormat').objid(),
            @key('otherCert').any()
        ),
    })


RevocationInfoChoice = asn.define 'RevocationInfoChoice', () ->
    @choice({
        crl: @use(rfc5280.CertificateList),
        other: @implicit(1).seq().obj(
            @key('otherRevInfoFormat').objid(),
            @key('otherRevInfo').any()
        )
    })


SignerInfo = asn.define 'SignerInfo', () ->
    @seq().obj(
        @key('version').use(CMSVersion),
        @key('sid').choice({
            issuerAndSerialNumber: @seq().obj(
                @key('issuer').use(rfc5280.Name),
                @key('serialNumber').use(rfc5280.CertificateSerialNumber)
            )
        }),
        @key('digestAlgorithm').use(rfc5280.AlgorithmIdentifier),
        @key('signedAttrs').optional().implicit(0).setof(common.Attribute),
        @key('signatureAlgorithm').use(rfc5280.AlgorithmIdentifier),
        @key('signature').octstr(),
        @key('unsignedAttrs').optional().implicit(1).setof(common.Attribute)
    )


CMSVersion = asn.define 'CMSVersion', () ->
    @int({
        0: 'v0',
        1: 'v1',
        2: 'v2',
        3: 'v3',
        4: 'v4',
        5: 'v5'
    })


SignedAttributes = asn.define 'SignedAttributes', () ->
    @setof(common.Attribute)


timestampResponse = exports

timestampResponse.CertificateChoices = CertificateChoices
timestampResponse.CMSVersion = CMSVersion
timestampResponse.EncapsulatedContent = EncapsulatedContent
timestampResponse.EncapsulatedContentInfo = EncapsulatedContentInfo
timestampResponse.PKIStatusInfo = PKIStatusInfo
timestampResponse.RevocationInfoChoice = RevocationInfoChoice
timestampResponse.SignedData = SignedData
timestampResponse.SignedDataTST = SignedDataTST
timestampResponse.SignerInfo = SignerInfo
timestampResponse.SignedAttributes = SignedAttributes
timestampResponse.TimestampResponse = TimestampResponse
timestampResponse.TimestampResponseTST = TimestampResponseTST
