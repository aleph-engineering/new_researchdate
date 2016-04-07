asn1_helpers = require './asn1_helpers'


verifyTimestamp = (artifactHash, responseBuffer)->
    asn1_helpers.parseTimestampResponse responseBuffer

    return true


exports.verifyTimestamp = verifyTimestamp
