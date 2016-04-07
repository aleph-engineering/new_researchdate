asn1_helpers = require '../lib/asn1_helpers'

Meteor.methods

    'server/timestamp': (hash) ->
        tsqBuffer = asn1_helpers.generateTimestampRequest hash

        @unblock()

        try # Build the options for the request to make
            requestOptions =
                headers:
                    'Content-Type': 'application/timestamp-query'
                body: tsqBuffer
                encoding: null

            if process.env.MOCK_TIMESTAMPING?
                response =
                    body: new Buffer 'binary'
            else # Perform the request to the TSA using the built options
                response = request.postSync 'https://freetsa.org/tsr', requestOptions


            date = new Date()
            # TODO:(Helen Garcia Glez) Replace server when selection TSA implemented.
            Timestamps.insert creationDate: date, hash: hash, server: 'https://freetsa.org/'

            return response.body
        catch e
            console.log e
            throw e
