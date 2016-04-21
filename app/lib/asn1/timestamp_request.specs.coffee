# FIXME: (@ariel) This is an ugly test implementation, can't think at this time in a better way of doing it


rfc5280 = require 'asn1.js/rfc/5280'
timestampRequest = require './timestamp_request'
common = require './common'


describe 'TimestampRequest module', ->
    it 'is defined', ->
        expect(timestampRequest).to.not.be.undefined


    describe 'TimestampRequest ASN Model', ->
        beforeEach ->
            @TimestampRequest = timestampRequest.TimestampRequest


        it 'is defined', ->
            expect(@TimestampRequest).to.not.be.undefined


        it 'contains "name" property with correct value', ->
            expect(@TimestampRequest).to.have.property 'name'
            expect(@TimestampRequest.name).to.equal 'TimestampRequest'


        it 'contains "body" property with provided callback', ->
            expect(@TimestampRequest).to.have.property 'body'
            expect(@TimestampRequest.body).to.be.a 'Function'


        it '"body" callback does the right model configuration', ->
            expectedTimestampRequestBodyFnResult = do Math.random
            expectedIntWithArgFnResult = do Math.random
            expectedUseFnResult = do Math.random
            expectedObjidFnResult = do Math.random
            expectedIntWithoutArgFnResult = do Math.random
            expectedBoolFnResult = do Math.random
            expectedSeqofFnResult = do Math.random
            callback = @TimestampRequest.body

            optionalStub =
                optional: ->
                    objid: -> expectedObjidFnResult
                    int: -> expectedIntWithoutArgFnResult
                    implicit: (arg) ->
                        if arg is 0
                            seqof: (arg0) ->
                                expectedSeqofFnResult if arg0 is rfc5280.Extension
            objStub = sinon.stub obj: ->
            objStub.obj.withArgs(
                expectedIntWithArgFnResult
                expectedUseFnResult
                expectedObjidFnResult
                expectedIntWithoutArgFnResult
                expectedBoolFnResult
                expectedSeqofFnResult
            ).returns expectedTimestampRequestBodyFnResult
            intWithArgStub = sinon.stub int: ->
            intWithArgStub.int.withArgs({1: 'v1'}).returns expectedIntWithArgFnResult
            useStub = sinon.stub use: ->
            useStub.use.withArgs(common.MessageImprint).returns expectedUseFnResult

            fakeContext = sinon.stub
                seq: ->
                key: ->
            fakeContext.seq.returns objStub
            fakeContext.key.withArgs('version').returns intWithArgStub
            fakeContext.key.withArgs('messageImprint').returns useStub
            fakeContext.key.withArgs('reqPolicy').returns optionalStub
            fakeContext.key.withArgs('nonce').returns optionalStub
            fakeContext.key.withArgs('certReq').returns def: (arg) -> (bool: -> expectedBoolFnResult) unless arg
            fakeContext.key.withArgs('extensions').returns optionalStub

            result = callback.call fakeContext

            expect(objStub.obj.calledOnce).to.be.true
            expect(fakeContext.key.calledWith 'version').to.be.true
            expect(fakeContext.key.calledWith 'messageImprint').to.be.true
            expect(fakeContext.key.calledWith 'reqPolicy').to.be.true
            expect(fakeContext.key.calledWith 'nonce').to.be.true
            expect(fakeContext.key.calledWith 'certReq').to.be.true
            expect(fakeContext.key.calledWith 'extensions').to.be.true

            expect(result).to.be.equal expectedTimestampRequestBodyFnResult


        it 'does not have any decoders', ->
            expect(@TimestampRequest).to.have.property 'decoders'
            expect(@TimestampRequest.decoders).to.be.an 'object'
            expect(@TimestampRequest.decoders).to.empty


        it 'does not have any encoders', ->
            expect(@TimestampRequest).to.have.property 'encoders'
            expect(@TimestampRequest.encoders).to.be.an 'object'
            expect(@TimestampRequest.encoders).to.empty
