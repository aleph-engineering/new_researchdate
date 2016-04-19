timestamping = require './timestamping'


describe 'Timestamping Module', ->
    it 'is defined', ->
        expect(timestamping).to.not.be.undefined

    describe 'TimestampGenerator class', ->
        beforeEach ->
            @timestampGenerator = new timestamping.TimestampGenerator()
            @timestampInsertMethod = sinon.stub Timestamps, 'insert'

        afterEach ->
            do @timestampInsertMethod.restore

        it 'is defined', ->
            expect(timestamping.TimestampGenerator).to.not.be.undefined

        describe '_buildTimestampRequestOptions Method', ->
            it 'is defined', ->
                expect(@timestampGenerator._buildTimestampRequestOptions).to.not.be.undefined

            it 'returns object with expected properties', ->
                tsrResponse = {}
                result = @timestampGenerator._buildTimestampRequestOptions tsrResponse
                expect(result).to.be.an 'object'

                expect(result).to.have.property 'headers'
                headers = result.headers
                expect(headers).to.have.property 'Content-Type'
                expect(headers['Content-Type']).to.equal 'application/timestamp-query'

                expect(result).to.have.property 'body'
                expect(result.body).to.equal tsrResponse

                expect(result).to.have.property 'encoding'
                expect(result.encoding).to.be.null

        describe '_saveTimestampRecord', ->
            it 'is defined', ->
                expect(@timestampGenerator._saveTimestampRecord).to.not.be.undefined

            it 'inserts a new Timestamp record with correct information', ->
                hash = "a4f56c8bba9" # arrange
                date = new Date().getTime()
                clock = sinon.useFakeTimers date

                # act
                @timestampGenerator._saveTimestampRecord hash

                # assert
                assert @timestampInsertMethod.calledOnce
                assert @timestampInsertMethod.calledWith
                    hash: hash, creationDate: new Date(date), server: 'https://freetsa.org/'

                do clock.restore

        describe '_makeTimestampRequest', ->
            it 'is defined', ->
                expect(@timestampGenerator._makeTimestampRequest).to.not.be.undefined

            it 'performs the tsr request to specified URL and using the given options and returns response', ->
                tsrUrl = "https://www.tsr-url.com" # arrange
                tsrRequestOptions = {}
                expectedPostSyncResult = "postSync response"
                postSyncMethod = sinon.stub request, 'postSync'
                postSyncMethod.onCall(0).returns expectedPostSyncResult

                # act
                result = @timestampGenerator._makeTimestampRequest [tsrUrl, tsrRequestOptions]

                # assert
                assert postSyncMethod.calledOnce
                assert postSyncMethod.calledWith [tsrUrl, tsrRequestOptions]
                expect(result).to.equal expectedPostSyncResult

                do postSyncMethod.restore

        describe '_generateTimestampRequest', ->
            it 'is defined', ->
                expect(@timestampGenerator._generateTimestampRequest).to.not.be.undefined

            it 'calls the proper timestamp request generation method', ->
                asn1_helpers = require '../../lib/asn1_helpers'
                generateTimestampRequestMethod = sinon.stub asn1_helpers, 'generateTimestampRequest'

                hash = "e897ab9cb"
                @timestampGenerator._generateTimestampRequest hash

                assert generateTimestampRequestMethod.calledOnce
                assert generateTimestampRequestMethod.calledWith hash

                do generateTimestampRequestMethod.restore

        describe 'timestamp', ->
            beforeEach ->
                @stubGenerateTimestampRequestMethod = (hash, expectedBuffer) ->
                    generateTimestampRequestMethod = sinon.stub @timestampGenerator, '_generateTimestampRequest'
                    generateTimestampRequestMethod.withArgs(hash).onFirstCall().returns expectedBuffer
                    generateTimestampRequestMethod

                @stubBuildOptionsMethod = (generatedBuffer, expectedOptions) ->
                    buildTimestampRequestOptionsMethod = sinon.stub @timestampGenerator, '_buildTimestampRequestOptions'
                    buildTimestampRequestOptionsMethod.withArgs(generatedBuffer).onFirstCall().returns expectedOptions
                    buildTimestampRequestOptionsMethod

                @stubMakeTimestampRequestMethod = (tsaServer, options, expectedResponse) ->
                    makeTimestampRequest = sinon.stub @timestampGenerator, '_makeTimestampRequest'
                    makeTimestampRequest.withArgs(tsaServer, options).onFirstCall().returns expectedResponse
                    makeTimestampRequest

            it 'is defined', ->
                expect(@timestampGenerator.timestamp).to.not.be.undefined


            it 'given hash, it returns the generated timestamp in TSA response body', ->
                hash = 'u983nxuxusw30w3'
                expectedResult = 190

                generatedBuffer = 'b'
                genTimestampRequestMethod = @stubGenerateTimestampRequestMethod hash, generatedBuffer

                builtOptions = 'opts'
                buildTimestampRequestOptionsMethod = @stubBuildOptionsMethod generatedBuffer, builtOptions

                timestampResponse = body: expectedResult
                makeTimestampRequest = @stubMakeTimestampRequestMethod @timestampGenerator._freeTSA, builtOptions, timestampResponse

                saveTimestampRecord = sinon.stub @timestampGenerator, '_saveTimestampRecord'

                # act
                result = @timestampGenerator.timestamp hash

                expect(result).to.equal expectedResult
                do genTimestampRequestMethod.restore
                do buildTimestampRequestOptionsMethod.restore
                do makeTimestampRequest.restore
                do saveTimestampRecord.restore

            it 'throws exception error when it happens', ->
                consoleLogMethod = sinon.stub console, 'log'
                error = new Error '123'
                generatedBuffer = 'b'
                genTimestampRequestMethod = @stubGenerateTimestampRequestMethod '123', generatedBuffer

                builtOptions = 'opts'
                buildTimestampRequestOptionsMethod = @stubBuildOptionsMethod generatedBuffer, builtOptions

                makeTimestampRequest = sinon.stub @timestampGenerator, '_makeTimestampRequest'
                makeTimestampRequest.throws error

                fn = => @timestampGenerator.timestamp '12312'

                expect(fn).to.throw error
                do consoleLogMethod.restore
                do genTimestampRequestMethod.restore
                do buildTimestampRequestOptionsMethod.restore
                do makeTimestampRequest.restore

            it 'logs exception error to console when it happens', ->
                consoleLogMethod = sinon.stub console, 'log'

                error = new Error '123'
                generatedBuffer = 'b'
                genTimestampRequestMethod = @stubGenerateTimestampRequestMethod '123', generatedBuffer

                builtOptions = 'opts'
                buildTimestampRequestOptionsMethod = @stubBuildOptionsMethod generatedBuffer, builtOptions

                makeTimestampRequest = sinon.stub @timestampGenerator, '_makeTimestampRequest'
                makeTimestampRequest.throws error

                expect(=> @timestampGenerator.timestamp '12312').to.throw error

                assert consoleLogMethod.calledOnce
                assert consoleLogMethod.calledWith error
                do consoleLogMethod.restore
                do genTimestampRequestMethod.restore
                do buildTimestampRequestOptionsMethod.restore
                do makeTimestampRequest.restore


    describe 'getTimestampGenerator method', ->
        it 'is defined', ->
            expect(timestamping.getTimestampGenerator).to.not.be.undefined

        it 'returns new instance of timestamping.TimestampGenerator class', ->
            timestampGenerator = timestamping.getTimestampGenerator()
            expect(timestampGenerator).to.be.an.instanceof timestamping.TimestampGenerator
