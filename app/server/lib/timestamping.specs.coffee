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


    describe '_saveTimestampRecord', ->
        beforeEach ->
            @_saveTimestampRecord = timestamping._saveTimestampRecord

        it 'is defined', ->
            expect(@_saveTimestampRecord).to.not.be.undefined

        it 'inserts a new Timestamp record with correct information', ->
            hash = "a4f56c8bba9" # arrange
            date = new Date().getTime();
            clock = sinon.useFakeTimers date
            insertMethod = sinon.spy Timestamps, 'insert'

            # act
            @_saveTimestampRecord hash

            # assert
            assert insertMethod.calledOnce
            assert insertMethod.calledWith hash: hash, creationDate: new Date(date), server: 'https://freetsa.org/'

            do insertMethod.restore
            do clock.restore

    describe '_makeTimestampRequest', ->
        beforeEach ->
            @_makeTimestampRequest = timestamping._makeTimestampRequest

        it 'is defined', ->
            expect(@_makeTimestampRequest).to.not.be.undefined

        it 'performs the tsr request to specified URL and using the given options and returns response', ->
            tsrUrl = "https://www.tsr-url.com" # arrange
            tsrRequestOptions = {}
            expectedPostSyncResult = "postSync response"
            postSyncMethod = sinon.stub request, 'postSync'
            postSyncMethod.onCall(0).returns expectedPostSyncResult

            # act
            result = @_makeTimestampRequest [tsrUrl, tsrRequestOptions]

            # assert
            assert postSyncMethod.calledOnce
            assert postSyncMethod.calledWith [tsrUrl, tsrRequestOptions]
            expect(result).to.equal expectedPostSyncResult

            do postSyncMethod.restore
