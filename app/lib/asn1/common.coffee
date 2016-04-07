asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'


MessageImprint = asn.define 'MessageImprint', () ->
    @seq().obj(
        @key('hashAlgorithm').use(rfc5280.AlgorithmIdentifier)
        @key('hashedMessage').octstr()
    )

Any = asn.define 'Any', () ->
    @any()

Attribute = asn.define 'Attribute', () ->
    @seq().obj(
        @key('attrType').objid(),
        @key('attrValues').setof(Any)
    )

PKCS7_CONTENT_TYPES = {
    "1 2 840 113549 1 7 1": "data",
    "1 2 840 113549 1 7 2": "signedData",
    "1 2 840 113549 1 7 3": "envelopedData",
    "1 2 840 113549 1 7 4": "signedAndEnvelopedData",
    "1 2 840 113549 1 7 5": "digestData",
    "1 2 840 113549 1 7 6": "encryptedData",
}

common = exports

common.MessageImprint = MessageImprint
common.Attribute = Attribute
common.PKCS7_CONTENT_TYPES = PKCS7_CONTENT_TYPES
