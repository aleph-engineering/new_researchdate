Meteor.methods
  'server/timestamp': (hash) ->
#    options =
#      params:
#        auto: 1,
#        hash: hash
#
#    HTTP.call 'POST', 'https://freetsa.org/tsr', options, (error, result) ->
#      if !error
#        console.log result

#    First we build the tsq (timestamping query) defined in the RFC 3161 standard
    fixedPrefixBuffer = new Buffer([0x30,0x56,0x02,0x01,0x01,0x30,0x51,0x30,0x0D,0x06,0x09,0x60,0x86,0x48,0x01,
      0x65,0x03,0x04,0x02,0x03,0x05,0x00,0x04,0x40]);
    hexBuffer = new Buffer(hash, 'hex')
    tsqBuffer = Buffer.concat([fixedPrefixBuffer, hexBuffer])

    options =
      headers:
        'Content-Type': 'application/timestamp-query'
      body: tsqBuffer
      encoding: null
#    try
#      response = request.postSync 'https://freetsa.org/tsr', options
#      return response.body
#    catch error
#      console.log error
    return tsqBuffer.toString()
