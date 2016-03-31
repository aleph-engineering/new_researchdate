Meteor.methods

    'server/timestamp': (hash) ->
        hashBuffer = new Buffer hash, 'hex'
        tsqBuffer = generateTimestampRequest hashBuffer

        @unblock()

        # Build the options for the request to make
        try
            requestOptions =
                headers:
                    'Content-Type': 'application/timestamp-query'
                body: tsqBuffer
                encoding: null

            # TODO: Remove this condition when found a better way of mocking the online timestamping
            if MOCK_TIMESTAMPING
                response =
                    body: new Buffer 'binary'
            else
                response = request.postSync 'https://freetsa.org/tsr', requestOptions
            # Perform the request to the TSA using the built options

            date = new Date()
            #            Timestamps.insert creationDate: date, hash: hash

            return response.body
        catch e
            console.log e
            throw e
