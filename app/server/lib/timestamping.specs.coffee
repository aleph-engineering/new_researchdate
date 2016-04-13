rewire = require 'rewire'
timestamping = require './timestamping'


describe 'Timestamping Module', ->
    it 'is defined', ->
        expect(timestamping).to.not.be.undefined

    describe '_buildTimestampRequestOptions Method', ->
        beforeEach ->
            @_buildTimestampRequestOptions = timestamping._buildTimestampRequestOptions

        it 'is defined', ->
            expect(@_buildTimestampRequestOptions).to.not.be.undefined

        it 'returns object with expected properties', ->
            tsrResponse = {}
            result = @_buildTimestampRequestOptions tsrResponse
            expect(result).to.be.an('object');

            expect(result).to.have.property 'headers'
            headers = result.headers
            expect(headers).to.have.property 'Content-Type'
            expect(headers['Content-Type']).to.equal 'application/timestamp-query'

            expect(result).to.have.property 'body'
            expect(result.body).to.equal tsrResponse

            expect(result).to.have.property 'encoding'
            expect(result.encoding).to.be.null
