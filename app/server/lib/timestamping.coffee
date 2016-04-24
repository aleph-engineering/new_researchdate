### Performs the corresponding operations to make timestamping of hashes sent from the client. ###
asn1_helpers = require '../../lib/asn1_helpers'


class TimestampGenerator

    _buildTimestampRequestOptions: (tsqBuffer) =>
        ### Constructs the options to make the Timestamp request using the given Timestamp query buffer.

            @param tsqBuffer: The timestamp query to build options for
        ###
        headers:
            'Content-Type': 'application/timestamp-query'
        body: tsqBuffer
        encoding: null


    _saveTimestampRecord: (hash) =>
        ### Saves information about the given timestamp in the Database.

            @param hash: The hash to extract the information to save from.
        ###
        date = new Date()
        # TODO:(Helen Garcia Glez) Replace server when selection TSA implemented.
        Timestamps.insert hash: hash, creationDate: date, server: 'https://freetsa.org/'


    _makeTimestampRequest: (tsaUrl, requestOptions) =>
        ### Makes the timestamp request, given the TSA url and request options.

            @param tsaUrl:          The url of the TSA to make to the request to.
            @param requestOptions:  The options to use in the request.
        ###
        if process.env.MOCK_TIMESTAMPING?
            return body: new Buffer 'binary'
        else # Perform the request to the TSA using the built options
            return request.postSync tsaUrl, requestOptions


    _generateTimestampRequest: (hash) =>
        ### Generates the timestamp request for the given hash.

            @param hash: The hash to prepare a timestamp request for.
        ###
        asn1_helpers.generateTimestampRequest hash


    timestamp: (hash) =>
        ### Generates the timestamp for the given hash.

            @param hash: The hash to generate the timestamp for.
        ###
        tsqBuffer = @_generateTimestampRequest hash
        requestOptions = @_buildTimestampRequestOptions tsqBuffer

        # Build the options for the request to make
        try
            response = @_makeTimestampRequest @_freeTSA, requestOptions
            @_saveTimestampRecord hash
            response.body
        catch e
            console.log e
            throw e


    _freeTSA: 'https://freetsa.org/tsr'


exports.TimestampGenerator = TimestampGenerator
exports.getTimestampGenerator = -> new TimestampGenerator()
