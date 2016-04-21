common = require './common'
timestampResponse = require './timestamp_response'


describe 'TimestampResponse module', ->
    it 'is defined', ->
        expect(timestampResponse).to.not.be.undefined


    describe 'ASN models', ->
        describe 'TimestampResponse', ->
            beforeEach ->
                @TimestampResponse = timestampResponse.TimestampResponse


            it 'is defined', ->
                expect(@TimestampResponse).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@TimestampResponse).to.have.property 'name'
                expect(@TimestampResponse.name).to.equal 'TimestampResponse'


            it 'contains "body" property with provided callback', ->
                expect(@TimestampResponse).to.have.property 'body'
                expect(@TimestampResponse.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedTimestampResponseBodyFnResult = do Math.random
                expectedUseFnResult = do Math.random
                expectedOptionalFnResult = do Math.random
                expectedArg0Value = do Math.random
                expectedArg1Value = do Math.random
                expectedOptionalSeqObjResult = do Math.random
                bodyFn = @TimestampResponse.body

                # Below are the stubs for the all the objects that interacted with in the whole method under test's
                # execution
                optionalStub =
                    optional: ->
                        seq: ->
                            obj: (arg0, arg1) ->
                                expectedOptionalSeqObjResult if arg0 is expectedArg0Value and arg1 is expectedArg1Value
                useStub = sinon.stub use: ->
                useStub.use.withArgs(timestampResponse.PKIStatusInfo).returns expectedUseFnResult
                objStub = sinon.stub
                    obj: ->
                    objid: ->
                    optional: ->
                objStub.obj.withArgs(expectedUseFnResult, expectedOptionalSeqObjResult).returns expectedTimestampResponseBodyFnResult
                objStub.objid.withArgs(common.PKCS7_CONTENT_TYPES).returns expectedArg0Value
                objStub.optional.returns
                    explicit: (arg0) ->
                        if  arg0 is 0
                            use: (arg1) ->
                                expectedArg1Value if arg1 is timestampResponse.SignedData

                # This is the fake context on top of which the method under test will execute
                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('status').returns useStub
                fakeContext.key.withArgs('timeStampToken').returns optionalStub
                fakeContext.key.withArgs('contentType').returns objStub
                fakeContext.key.withArgs('content').returns objStub

                # The actual call to the method to test
                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(result).to.be.equal expectedTimestampResponseBodyFnResult


            it 'does not have any decoders', ->
                expect(@TimestampResponse).to.have.property 'decoders'
                expect(@TimestampResponse.decoders).to.be.an 'object'
                expect(@TimestampResponse.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@TimestampResponse).to.have.property 'encoders'
                expect(@TimestampResponse.encoders).to.be.an 'object'
                expect(@TimestampResponse.encoders).to.empty
