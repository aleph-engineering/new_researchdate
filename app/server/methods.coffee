Meteor.methods
  'server/timestamp': (hash) ->
    hashBuffer = new Buffer hash, 'hex'
    tsqBuffer = generateTimestampRequest hashBuffer

    @unblock()
    try
      requestOptions =
        headers:
          'Content-Type': 'application/timestamp-query'
        body: tsqBuffer
        encoding: null
      response = request.postSync 'https://freetsa.org/tsr', requestOptions
      return response.body
    catch e
      console.log e
      throw e
