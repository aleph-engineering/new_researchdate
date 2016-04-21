asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'
common = require './common'


TimestampRequest = asn.define 'TimestampRequest', () ->
    @seq().obj(
        @key('version').int 1: 'v1'
        @key('messageImprint').use common.MessageImprint
        @key('reqPolicy').optional().objid()
        @key('nonce').optional().int()
        @key('certReq').def(no).bool()
        @key('extensions').optional().implicit(0).seqof rfc5280.Extension
    )


exports.TimestampRequest = TimestampRequest
