asn1_helpers = require '../lib/asn1_helpers'

saveTimestampRecord = (hash) ->
    date = new Date()
    # TODO:(Helen Garcia Glez) Replace server when selection TSA implemented.
    Timestamps.insert hash: hash, creationDate: date, server: 'https://freetsa.org/'


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

            saveTimestampRecord hash

            return response.body
        catch e
            console.log e
            throw e


exports.saveTimestampRecord = saveTimestampRecord
