# ASN.1 structure for the timestamp request and response defined in RFC 3161

@generateTimestampRequest = (hashBuffer) ->
    Ber = require('asn1').Ber
    writer = new Ber.Writer()
    writer.startSequence()
    writer.writeInt 1 # version
    writer.startSequence() # messageImprint
    writer.startSequence() # hashAlgorithm
    writer.writeOID HASHES.sha256.oid # algorithm
    writer.endSequence()
    writer.writeBuffer hashBuffer, Ber.OctetString # hashedMessage
    writer.endSequence()
    writer.writeBoolean true # certReq
    writer.endSequence()
    return writer.buffer
