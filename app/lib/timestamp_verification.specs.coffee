tsrHelpers = require './tsr_helpers'
tsv = require './timestamp_verification'
rsaSign = require 'jsrsasign'


describe 'TimestampVerification module', ->
    it 'is defined', ->
        expect(tsv).not.to.be.undefined


    describe 'TimestampVerifier class', ->
        beforeEach ->
            @TimestampVerifier = tsv.TimestampVerifier


        it 'is defined', ->
            expect(@TimestampVerifier).not.to.be.true


        describe '_getSignature', ->
            it 'is defined', ->
                expect(new @TimestampVerifier()._getSignature).not.be.undefined


            it 'returns correct object', ->
                timestampVerifier = new @TimestampVerifier()
                actualSignature = timestampVerifier._getSignature()
                expect(actualSignature).to.be.instanceOf rsaSign.Signature
                expect(actualSignature.algName).to.be.equal 'SHA1withRSA'


        describe 'verify method', ->
            it 'is defined', ->
                expect(new @TimestampVerifier('a', 'b').verify).not.to.be.undefined


            it 'artifact\'s hash and tsa\'s response hash do not match, returns false', ->
                artifactHash = '1234'
                tsrHash = '4321'
                tsaResponseBuffer = 'buffer'

                responseWrapper = sinon.stub getHashHex: ->
                responseWrapper.getHashHex.returns tsrHash
                getTSRWrapper = sinon.stub tsrHelpers, 'getTSRWrapper'
                getTSRWrapper.withArgs(tsaResponseBuffer).returns responseWrapper

                timestampVerifier = new @TimestampVerifier artifactHash, tsaResponseBuffer
                result = timestampVerifier.verify()

                expect(result).to.be.false
                assert getTSRWrapper.calledOnce
                assert getTSRWrapper.calledWithExactly tsaResponseBuffer
                assert responseWrapper.getHashHex.calledOnce

                do getTSRWrapper.restore


            it 'artifact\'s hash and tsa\'s response hash do match, but signature verification fails, returns false', ->
                expectedSignedContentBufferHex = do Math.random
                expectedSignature = do Math.random
                expectedPublicKey = do Math.random
                expectedResult = do Math.random

                artifactHash = '1234'
                tsrHash = '1234'
                tsaResponseBuffer = 'buffer'

                responseWrapper = sinon.stub
                    getHashHex: ->
                    getSignedContent: ->
                    getSignature: ->
                    getPublicKey: ->
                responseWrapper.getHashHex.returns tsrHash
                responseWrapper.getSignedContent.returns
                    toString: (arg) -> expectedSignedContentBufferHex if arg is 'hex'
                responseWrapper.getSignature.returns
                    toString: (arg) -> expectedSignature if arg is 'hex'
                responseWrapper.getPublicKey.returns expectedPublicKey

                getTSRWrapper = sinon.stub tsrHelpers, 'getTSRWrapper'
                getTSRWrapper.withArgs(tsaResponseBuffer).returns responseWrapper

                expectedSignatureStub = sinon.stub
                    init: ->
                    updateHex: ->
                    verify: ->
                expectedSignatureStub.verify.withArgs(expectedSignature).returns expectedResult

                timestampVerifier = new @TimestampVerifier artifactHash, tsaResponseBuffer
                timestampVerifierGetSignature = sinon.stub timestampVerifier, '_getSignature'
                timestampVerifierGetSignature.returns expectedSignatureStub

                result = timestampVerifier.verify()

                assert(
                    expectedSignatureStub.init.calledOnce
                    'sig.init was not called even once'
                )
                assert(
                    expectedSignatureStub.init.calledWithExactly expectedPublicKey
                    'sig.init was not called with correct arguments'
                )
                assert(
                    expectedSignatureStub.init.calledBefore expectedSignatureStub.updateHex
                    'sig.init was not called before sig.updateHex'
                )

                assert(
                    expectedSignatureStub.updateHex.calledOnce
                    'sig.updateHex was not called even once'
                )
                assert(
                    expectedSignatureStub.updateHex.calledWithExactly expectedSignedContentBufferHex
                    'sig.updateHex was not called with correct arguments'
                )
                assert(
                    expectedSignatureStub.updateHex.calledBefore expectedSignatureStub.verify
                    'sig.updateHex was not called before sig.verify'
                )

                assert(
                    expectedSignatureStub.verify.calledOnce,
                    'sig.verify(...) was not called even once'
                )
                assert(
                    expectedSignatureStub.verify.calledWithExactly expectedSignature
                    'sig.verify(...) was not called even once'
                )
                expect(result).to.be.equal expectedResult

                do getTSRWrapper.restore
