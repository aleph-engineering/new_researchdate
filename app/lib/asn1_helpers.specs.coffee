hashes = require './asn1/hash_helpers'
asn1_helpers = require './asn1_helpers'
timestampRequest = require './asn1/timestamp_request'


describe 'Asn1Helpers Module', ->
    it 'is defined', ->
        expect(asn1_helpers).not.to.be.undefined


    describe 'TimestampRequestGenerator class', ->
        beforeEach ->
            @hash = 'a1c2121c'
            @TimestampRequestGenerator = asn1_helpers.TimestampRequestGenerator
            @encode = sinon.stub timestampRequest.TimestampRequest, 'encode'
            @timestampRequestGenerator = new @TimestampRequestGenerator @hash

        afterEach ->
            do @encode.restore


        it 'is defined', ->
            expect(@TimestampRequestGenerator).not.to.be.undefined


        describe 'generate method', ->
            it 'is defined', ->
                expect(@timestampRequestGenerator.generate).not.to.be.undefined


            it 'generates timestamp request properly', ->
                expectedOutput = do Math.random
                bufferFromHash = do Math.random

                genBufferFromHash = sinon.stub @timestampRequestGenerator, '_generateBufferFromHash'
                genBufferFromHash.withArgs(@timestampRequestGenerator.hash).returns bufferFromHash
                @encode.withArgs(
                    version: 1
                    messageImprint:
                        hashAlgorithm:
                            algorithm: hashes.HASHES.sha256.oid.split '.'
                        hashedMessage: bufferFromHash
                    certReq: yes
                , 'der').returns expectedOutput

                actualOutput = @timestampRequestGenerator.generate()

                expect(actualOutput).to.be.equal expectedOutput
                do genBufferFromHash.restore
