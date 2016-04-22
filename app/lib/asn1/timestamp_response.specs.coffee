# FIXME: (@ariel) This is an ugly test implementation, can't think at this time in a better way of doing it

common = require './common'
timestampResponse = require './timestamp_response'
rfc5280 = require 'asn1.js/rfc/5280'


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
                objStub.obj.withArgs(
                    expectedUseFnResult,
                    expectedOptionalSeqObjResult
                ).returns expectedTimestampResponseBodyFnResult
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
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith expectedUseFnResult, expectedOptionalSeqObjResult).to.be.true
                expect(result).to.be.equal expectedTimestampResponseBodyFnResult


            it 'does not have any decoders', ->
                expect(@TimestampResponse).to.have.property 'decoders'
                expect(@TimestampResponse.decoders).to.be.an 'object'
                expect(@TimestampResponse.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@TimestampResponse).to.have.property 'encoders'
                expect(@TimestampResponse.encoders).to.be.an 'object'
                expect(@TimestampResponse.encoders).to.empty


        describe 'TimestampResponseTST', ->
            beforeEach ->
                @TimestampResponseTST = timestampResponse.TimestampResponseTST


            it 'is defined', ->
                expect(@TimestampResponseTST).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@TimestampResponseTST).to.have.property 'name'
                expect(@TimestampResponseTST.name).to.equal 'TimestampResponse'


            it 'contains "body" property with provided callback', ->
                expect(@TimestampResponseTST).to.have.property 'body'
                expect(@TimestampResponseTST.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedTimestampResponseBodyFnResult = do Math.random
                expectedUseFnResult = do Math.random
                expectedArg0Value = do Math.random
                expectedArg1Value = do Math.random
                expectedOptionalSeqObjResult = do Math.random
                bodyFn = @TimestampResponseTST.body

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
                objStub.obj.withArgs(
                    expectedUseFnResult,
                    expectedOptionalSeqObjResult
                ).returns expectedTimestampResponseBodyFnResult
                objStub.objid.withArgs(common.PKCS7_CONTENT_TYPES).returns expectedArg0Value
                objStub.optional.returns
                    explicit: (arg0) ->
                        if  arg0 is 0
                            use: (arg1) ->
                                expectedArg1Value if arg1 is timestampResponse.SignedDataTST

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
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith expectedUseFnResult, expectedOptionalSeqObjResult).to.be.true
                expect(result).to.be.equal expectedTimestampResponseBodyFnResult


            it 'does not have any decoders', ->
                expect(@TimestampResponseTST).to.have.property 'decoders'
                expect(@TimestampResponseTST.decoders).to.be.an 'object'
                expect(@TimestampResponseTST.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@TimestampResponseTST).to.have.property 'encoders'
                expect(@TimestampResponseTST.encoders).to.be.an 'object'
                expect(@TimestampResponseTST.encoders).to.empty


        describe 'PKIStatusInfo', ->
            beforeEach ->
                @PKIStatusInfo = timestampResponse.PKIStatusInfo


            it 'is defined', ->
                expect(@PKIStatusInfo).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@PKIStatusInfo).to.have.property 'name'
                expect(@PKIStatusInfo.name).to.equal 'PKIStatusInfo'


            it 'contains "body" property with provided callback', ->
                expect(@PKIStatusInfo).to.have.property 'body'
                expect(@PKIStatusInfo.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedIntFnResult = do Math.random
                expectedUtf8strResult = do Math.random
                expectedBitstrFnResult = do Math.random
                # Above are defined the result serving as contracts to determining whether the method under test
                # executes correctly

                bodyFn = @PKIStatusInfo.body
                intStub = int: (arg0) ->
                    expect(arg0).to.be.eql
                        0: 'granted'
                        1: 'grantedWithMods'
                        2: 'rejection'
                        3: 'waiting'
                        4: 'revocationWarning'
                        5: 'revocationNotification'
                    expectedIntFnResult

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(
                    expectedIntFnResult,
                    expectedUtf8strResult,
                    expectedBitstrFnResult
                ).returns expectedResult
                objStub1 = sinon.stub obj: ->
                expectedUtf8str = do Math.random
                objStub1.obj.withArgs(expectedUtf8str).returns expectedUtf8strResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('status').returns intStub
                fakeContext.key.withArgs('statusString').returns optional: -> seq: -> objStub1
                fakeContext.key.withArgs('text').returns optional: -> utf8str: -> expectedUtf8str
                fakeContext.key.withArgs('failInfo').returns
                    optional: ->
                        bitstr: (arg0) ->
                            expect(arg0).to.be.eql
                                '0': 'badAlg',
                                '2': 'badRequest',
                                '5': 'badDataFormat',
                                '14': 'timeNotAvailable',
                                '15': 'unacceptedPolicy',
                                '16': 'unacceptedExtension',
                                '17': 'addInfoNotAvailable',
                                '25': 'systemFailure'
                            expectedBitstrFnResult

                result = bodyFn.call fakeContext

                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith(
                    expectedIntFnResult,
                    expectedUtf8strResult,
                    expectedBitstrFnResult
                )).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@PKIStatusInfo).to.have.property 'decoders'
                expect(@PKIStatusInfo.decoders).to.be.an 'object'
                expect(@PKIStatusInfo.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@PKIStatusInfo).to.have.property 'encoders'
                expect(@PKIStatusInfo.encoders).to.be.an 'object'
                expect(@PKIStatusInfo.encoders).to.empty


        describe 'SignedData', ->
            beforeEach ->
                @SignedData = timestampResponse.SignedData


            it 'is defined', ->
                expect(@SignedData).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@SignedData).to.have.property 'name'
                expect(@SignedData.name).to.equal 'SignedData'


            it 'contains "body" property with provided callback', ->
                expect(@SignedData).to.have.property 'body'
                expect(@SignedData.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedUse0FnResult = do Math.random
                expectedSetof0FnResult = do Math.random
                expectedUse1FnResult = do Math.random
                expectedSetof1FnResult = do Math.random
                expectedSetof2FnResult = do Math.random
                expectedSetof3FnResult = do Math.random
                bodyFn = @SignedData.body

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(
                    expectedUse0FnResult,
                    expectedSetof0FnResult,
                    expectedUse1FnResult,
                    expectedSetof1FnResult,
                    expectedSetof2FnResult,
                    expectedSetof3FnResult
                ).returns expectedResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('version').returns
                    use: (arg) -> expectedUse0FnResult  if arg is timestampResponse.CMSVersion
                fakeContext.key.withArgs('digestAlgorithms').returns
                    setof: (arg) -> expectedSetof0FnResult if arg is rfc5280.AlgorithmIdentifier
                fakeContext.key.withArgs('encapContentInfo').returns
                    use: (arg) -> expectedUse1FnResult if arg is timestampResponse.EncapsulatedContentInfo
                fakeContext.key.withArgs('certificates').returns
                    optional: ->
                        implicit: (arg) ->
                            if arg is 0
                                setof: (arg0) -> expectedSetof1FnResult if arg0 is timestampResponse.CertificateChoices
                fakeContext.key.withArgs('crls').returns
                    optional: ->
                        implicit: (arg) ->
                            if arg is 1
                                setof: (arg0) ->
                                    expectedSetof2FnResult if arg0 is timestampResponse.RevocationInfoChoice
                fakeContext.key.withArgs('signerInfos').returns
                    setof: (arg) -> expectedSetof3FnResult  if arg is timestampResponse.SignerInfo

                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith(
                    expectedUse0FnResult,
                    expectedSetof0FnResult,
                    expectedUse1FnResult,
                    expectedSetof1FnResult,
                    expectedSetof2FnResult,
                    expectedSetof3FnResult
                )).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@SignedData).to.have.property 'decoders'
                expect(@SignedData.decoders).to.be.an 'object'
                expect(@SignedData.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@SignedData).to.have.property 'encoders'
                expect(@SignedData.encoders).to.be.an 'object'
                expect(@SignedData.encoders).to.empty
