Meteor.methods

    'server/timestamp': (hash) ->
        tsqBuffer = generateTimestampRequest hash

        @unblock()

        try
# Build the options for the request to make
            requestOptions =
                headers:
                    'Content-Type': 'application/timestamp-query'
                body: tsqBuffer
                encoding: null

            # TODO: Remove this condition when found a better way of mocking the online timestamping
            if process.env.MOCK_TIMESTAMPING?
                response =
                    body: new Buffer 'binary'
            else
# Perform the request to the TSA using the built options
                response = request.postSync 'https://freetsa.org/tsr', requestOptions


            date = new Date()
            # TODO:(Helen Garcia Glez) Replace server when selection TSA implemented.
            Timestamps.insert creationDate: date, hash: hash, server: 'https://freetsa.org/'

            return response.body
        catch e
            console.log e
            throw e


    'server/verify': (tsr, origin)->
        console.log tsr.lastModified
        console.log origin.lastModified
