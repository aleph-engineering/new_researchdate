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


        describe 'SignedDataTST', ->
            beforeEach ->
                @SignedDataTST = timestampResponse.SignedDataTST


            it 'is defined', ->
                expect(@SignedDataTST).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@SignedDataTST).to.have.property 'name'
                expect(@SignedDataTST.name).to.equal 'SignedData'


            it 'contains "body" property with provided callback', ->
                expect(@SignedDataTST).to.have.property 'body'
                expect(@SignedDataTST.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedUse0FnResult = do Math.random
                expectedSetof0FnResult = do Math.random
                expectedUse1FnResult = do Math.random
                expectedSetof1FnResult = do Math.random
                expectedSetof2FnResult = do Math.random
                expectedSetof3FnResult = do Math.random
                bodyFn = @SignedDataTST.body

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
                    use: (arg) -> expectedUse1FnResult if arg is timestampResponse.EncapsulatedContentInfoTST
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
                expect(@SignedDataTST).to.have.property 'decoders'
                expect(@SignedDataTST.decoders).to.be.an 'object'
                expect(@SignedDataTST.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@SignedDataTST).to.have.property 'encoders'
                expect(@SignedDataTST.encoders).to.be.an 'object'
                expect(@SignedDataTST.encoders).to.empty


        describe 'EncapsulatedContentInfo', ->
            beforeEach ->
                @EncapsulatedContentInfo = timestampResponse.EncapsulatedContentInfo


            it 'is defined', ->
                expect(@EncapsulatedContentInfo).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@EncapsulatedContentInfo).to.have.property 'name'
                expect(@EncapsulatedContentInfo.name).to.equal 'EncapsulatedContentInfo'


            it 'contains "body" property with provided callback', ->
                expect(@EncapsulatedContentInfo).to.have.property 'body'
                expect(@EncapsulatedContentInfo.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedObjidFnResult = do Math.random
                expectedUseFnResult = do Math.random
                bodyFn = @EncapsulatedContentInfo.body

                objStub = sinon.stub
                    obj: ->
                objStub.obj.withArgs(expectedObjidFnResult, expectedUseFnResult).returns expectedResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('eContentType').returns objid: -> expectedObjidFnResult
                fakeContext.key.withArgs('eContent').returns
                    use: (arg) -> expectedUseFnResult if arg is timestampResponse.EncapsulatedContent

                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith expectedObjidFnResult, expectedUseFnResult).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@EncapsulatedContentInfo).to.have.property 'decoders'
                expect(@EncapsulatedContentInfo.decoders).to.be.an 'object'
                expect(@EncapsulatedContentInfo.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@EncapsulatedContentInfo).to.have.property 'encoders'
                expect(@EncapsulatedContentInfo.encoders).to.be.an 'object'
                expect(@EncapsulatedContentInfo.encoders).to.empty


        describe 'EncapsulatedContentInfoTST', ->
            beforeEach ->
                @EncapsulatedContentInfoTST = timestampResponse.EncapsulatedContentInfoTST


            it 'is defined', ->
                expect(@EncapsulatedContentInfoTST).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@EncapsulatedContentInfoTST).to.have.property 'name'
                expect(@EncapsulatedContentInfoTST.name).to.equal 'EncapsulatedContentInfoTST'


            it 'contains "body" property with provided callback', ->
                expect(@EncapsulatedContentInfoTST).to.have.property 'body'
                expect(@EncapsulatedContentInfoTST.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedObjidFnResult = do Math.random
                expectedUseFnResult = do Math.random
                bodyFn = @EncapsulatedContentInfoTST.body

                objStub = sinon.stub
                    obj: ->
                objStub.obj.withArgs(expectedObjidFnResult, expectedUseFnResult).returns expectedResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('eContentType').returns objid: -> expectedObjidFnResult
                fakeContext.key.withArgs('eContent').returns
                    use: (arg) -> expectedUseFnResult if arg is timestampResponse.EncapsulatedContentTST

                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith expectedObjidFnResult, expectedUseFnResult).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@EncapsulatedContentInfoTST).to.have.property 'decoders'
                expect(@EncapsulatedContentInfoTST.decoders).to.be.an 'object'
                expect(@EncapsulatedContentInfoTST.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@EncapsulatedContentInfoTST).to.have.property 'encoders'
                expect(@EncapsulatedContentInfoTST.encoders).to.be.an 'object'
                expect(@EncapsulatedContentInfoTST.encoders).to.empty


        describe 'EncapsulatedContent', ->
            beforeEach ->
                @EncapsulatedContent = timestampResponse.EncapsulatedContent


            it 'is defined', ->
                expect(@EncapsulatedContent).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@EncapsulatedContent).to.have.property 'name'
                expect(@EncapsulatedContent.name).to.equal 'EncapsulatedContent'


            it 'contains "body" property with provided callback', ->
                expect(@EncapsulatedContent).to.have.property 'body'
                expect(@EncapsulatedContent.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                bodyFn = @EncapsulatedContent.body

                fakeContext = sinon.stub
                    optional: ->
                fakeContext.optional.returns explicit: (arg) -> (octstr: -> expectedResult) if arg is 0

                result = bodyFn.call fakeContext

                expect(fakeContext.optional.calledOnce).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@EncapsulatedContent).to.have.property 'decoders'
                expect(@EncapsulatedContent.decoders).to.be.an 'object'
                expect(@EncapsulatedContent.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@EncapsulatedContent).to.have.property 'encoders'
                expect(@EncapsulatedContent.encoders).to.be.an 'object'
                expect(@EncapsulatedContent.encoders).to.empty


        describe 'EncapsulatedContentTST', ->
            beforeEach ->
                @EncapsulatedContentTST = timestampResponse.EncapsulatedContentTST


            it 'is defined', ->
                expect(@EncapsulatedContentTST).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@EncapsulatedContentTST).to.have.property 'name'
                expect(@EncapsulatedContentTST.name).to.equal 'EncapsulatedContentTST'


            it 'contains "body" property with provided callback', ->
                expect(@EncapsulatedContentTST).to.have.property 'body'
                expect(@EncapsulatedContentTST.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                bodyFn = @EncapsulatedContentTST.body

                fakeContext = sinon.stub
                    optional: ->
                fakeContext.optional.returns explicit: (arg) ->
                    if arg is 0
                        octstr: ->
                            contains: (arg0) ->
                                expectedResult if arg0 is timestampResponse.TSTInfo

                result = bodyFn.call fakeContext

                expect(fakeContext.optional.calledOnce).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@EncapsulatedContentTST).to.have.property 'decoders'
                expect(@EncapsulatedContentTST.decoders).to.be.an 'object'
                expect(@EncapsulatedContentTST.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@EncapsulatedContentTST).to.have.property 'encoders'
                expect(@EncapsulatedContentTST.encoders).to.be.an 'object'
                expect(@EncapsulatedContentTST.encoders).to.empty


        describe 'TSTInfo', ->
            beforeEach ->
                @TSTInfo = timestampResponse.TSTInfo


            it 'is defined', ->
                expect(@TSTInfo).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@TSTInfo).to.have.property 'name'
                expect(@TSTInfo.name).to.equal 'TSTInfo'


            it 'contains "body" property with provided callback', ->
                expect(@TSTInfo).to.have.property 'body'
                expect(@TSTInfo.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedIntFnResult = do Math.random
                expectedObjidFnResult = do Math.random
                expectedUseFnResult = do Math.random
                expectedInt0FnResult = do Math.random
                expectedGenTimeFnResult = do Math.random
                expectedAccuracyFnResult = do Math.random
                expectedBoolFnResult = do Math.random
                expectedInt1FnResult = do Math.random
                expectedInt2FnResult = do Math.random
                expectedUse0FnResult = do Math.random
                expectedSeqofFnResult = do Math.random
                bodyFn = @TSTInfo.body

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(
                    expectedIntFnResult
                    expectedObjidFnResult
                    expectedUseFnResult
                    expectedInt0FnResult
                    expectedGenTimeFnResult
                    expectedAccuracyFnResult
                    expectedBoolFnResult
                    expectedInt2FnResult
                    expectedUse0FnResult
                    expectedSeqofFnResult
                ).returns expectedResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('version').returns
                    int: (arg) ->
                        expect(arg).to.be.eql 1: 'v1'
                        expectedIntFnResult
                fakeContext.key.withArgs('policy').returns objid: -> expectedObjidFnResult
                fakeContext.key.withArgs('messageImprint').returns
                    use: (arg) -> expectedUseFnResult if arg is common.MessageImprint
                fakeContext.key.withArgs('serialNumber').returns int: -> expectedInt0FnResult
                fakeContext.key.withArgs('genTime').returns gentime: -> expectedGenTimeFnResult
                fakeContext.key.withArgs('seconds').returns optional: -> int: -> expectedInt1FnResult
                fakeContext.key.withArgs('accuracy').returns
                    optional: -> seq: -> obj: (arg) -> expectedAccuracyFnResult if arg is expectedInt1FnResult
                fakeContext.key.withArgs('ordering').returns def: (arg) -> (bool: -> expectedBoolFnResult) unless arg
                fakeContext.key.withArgs('nonce').returns optional: -> int: -> expectedInt2FnResult
                fakeContext.key.withArgs('tsa').returns
                    optional: ->
                        explicit: (arg) ->
                            if arg is 0
                                use: (arg0) ->
                                    expectedUse0FnResult if arg0 is rfc5280.GeneralName
                fakeContext.key.withArgs('extensions').returns
                    optional: ->
                        implicit: (arg) ->
                            if arg is 1
                                seqof: (arg0) ->
                                    expectedSeqofFnResult if arg0 is rfc5280.Extension

                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objStub.obj.calledOnce).to.be.true
                expect(objStub.obj.calledWith(
                    expectedIntFnResult
                    expectedObjidFnResult
                    expectedUseFnResult
                    expectedInt0FnResult
                    expectedGenTimeFnResult
                    expectedAccuracyFnResult
                    expectedBoolFnResult
                    expectedInt2FnResult
                    expectedUse0FnResult
                    expectedSeqofFnResult
                )).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@TSTInfo).to.have.property 'decoders'
                expect(@TSTInfo.decoders).to.be.an 'object'
                expect(@TSTInfo.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@TSTInfo).to.have.property 'encoders'
                expect(@TSTInfo.encoders).to.be.an 'object'
                expect(@TSTInfo.encoders).to.empty


        describe 'CertificateChoices', ->
            beforeEach ->
                @CertificateChoices = timestampResponse.CertificateChoices


            it 'is defined', ->
                expect(@CertificateChoices).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@CertificateChoices).to.have.property 'name'
                expect(@CertificateChoices.name).to.equal 'CertificateChoices'


            it 'contains "body" property with provided callback', ->
                expect(@CertificateChoices).to.have.property 'body'
                expect(@CertificateChoices.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedCertificate = do Math.random
                expectedImplicit = do Math.random
                expectedImplicit1 = do Math.random
                expectedImplicit2 = do Math.random
                expectedOther = do Math.random
                expectedOther1 = do Math.random
                expectedOther2 = do Math.random
                bodyFn = @CertificateChoices.body

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(expectedOther1, expectedOther2).returns expectedOther

                fakeContext = sinon.stub
                    key: ->
                    use: ->
                    choice: ->
                    implicit: ->
                fakeContext.choice.withArgs(
                    certificate: expectedCertificate
                    extendedCertificate: expectedImplicit
                    v1AttrCert: expectedImplicit1
                    v2AttrCert: expectedImplicit2
                    other: expectedOther
                ).returns expectedResult
                fakeContext.use.withArgs(rfc5280.Certificate).returns expectedCertificate
                fakeContext.implicit.withArgs(0).returns use: (arg) -> expectedImplicit if arg is rfc5280.Certificate
                fakeContext.implicit.withArgs(1).returns use: (arg) -> expectedImplicit1 if arg is rfc5280.Certificate
                fakeContext.implicit.withArgs(2).returns use: (arg) -> expectedImplicit2 if arg is rfc5280.Certificate
                fakeContext.implicit.withArgs(3).returns seq: -> objStub
                fakeContext.key.withArgs('otherCertFormat').returns objid: -> expectedOther1
                fakeContext.key.withArgs('otherCert').returns any: -> expectedOther2

                result = bodyFn.call fakeContext

                expect(fakeContext.choice.calledOnce).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@CertificateChoices).to.have.property 'decoders'
                expect(@CertificateChoices.decoders).to.be.an 'object'
                expect(@CertificateChoices.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@CertificateChoices).to.have.property 'encoders'
                expect(@CertificateChoices.encoders).to.be.an 'object'
                expect(@CertificateChoices.encoders).to.empty


        describe 'RevocationInfoChoice', ->
            beforeEach ->
                @RevocationInfoChoice = timestampResponse.RevocationInfoChoice


            it 'is defined', ->
                expect(@RevocationInfoChoice).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@RevocationInfoChoice).to.have.property 'name'
                expect(@RevocationInfoChoice.name).to.equal 'RevocationInfoChoice'


            it 'contains "body" property with provided callback', ->
                expect(@RevocationInfoChoice).to.have.property 'body'
                expect(@RevocationInfoChoice.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedCrl = do Math.random
                expectedImplicit = do Math.random
                expectedObjid = do Math.random
                expectedAny = do Math.random
                bodyFn = @RevocationInfoChoice.body

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(expectedObjid, expectedAny).returns expectedImplicit

                fakeContext = sinon.stub
                    choice: ->
                    use: ->
                    implicit: ->
                    key: ->
                fakeContext.choice.withArgs(
                    crl: expectedCrl
                    other: expectedImplicit
                ).returns expectedResult
                fakeContext.use.withArgs(rfc5280.CertificateList).returns expectedCrl
                fakeContext.implicit.withArgs(1).returns seq: -> objStub
                fakeContext.key.withArgs('otherRevInfoFormat').returns objid: -> expectedObjid
                fakeContext.key.withArgs('otherRevInfo').returns any: -> expectedAny

                result = bodyFn.call fakeContext

                expect(fakeContext.choice.calledOnce).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@RevocationInfoChoice).to.have.property 'decoders'
                expect(@RevocationInfoChoice.decoders).to.be.an 'object'
                expect(@RevocationInfoChoice.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@RevocationInfoChoice).to.have.property 'encoders'
                expect(@RevocationInfoChoice.encoders).to.be.an 'object'
                expect(@RevocationInfoChoice.encoders).to.empty


        describe 'SignerInfo', ->
            beforeEach ->
                @SignerInfo = timestampResponse.SignerInfo


            it 'is defined', ->
                expect(@SignerInfo).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@SignerInfo).to.have.property 'name'
                expect(@SignerInfo.name).to.equal 'SignerInfo'


            it 'contains "body" property with provided callback', ->
                expect(@SignerInfo).to.have.property 'body'
                expect(@SignerInfo.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                expectedVersion = do Math.random
                expectedSidResult = do Math.random
                expectedIssueObj = do Math.random
                expectedIssuer = do Math.random
                expectedSerialNumber = do Math.random
                expectedDigestAlgorithm = do Math.random
                expectedSignedAttrs = do Math.random
                expectedSignatureAlgorithm = do Math.random
                expectedSignature = do Math.random
                expectedUnsignedAttrs = do Math.random

                bodyFn = @SignerInfo.body

                objStub = sinon.stub obj: ->
                objStub.obj.withArgs(
                    expectedVersion
                    expectedSidResult
                    expectedDigestAlgorithm
                    expectedSignedAttrs
                    expectedSignatureAlgorithm
                    expectedSignature
                    expectedUnsignedAttrs
                ).returns expectedResult
                objStub.obj.withArgs(expectedIssuer, expectedSerialNumber).returns expectedIssueObj

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objStub
                fakeContext.key.withArgs('version').returns
                    use: (arg) -> expectedVersion if arg is timestampResponse.CMSVersion
                fakeContext.key.withArgs('sid').returns
                    choice: (arg) ->
                        expect(arg).to.be.eql issuerAndSerialNumber: expectedIssueObj
                        expectedSidResult
                fakeContext.key.withArgs('issuer').returns use: (arg) -> expectedIssuer if arg is rfc5280.Name
                fakeContext.key.withArgs('serialNumber').returns
                    use: (arg) -> expectedSerialNumber if arg is rfc5280.CertificateSerialNumber
                fakeContext.key.withArgs('digestAlgorithm').returns
                    use: (arg) -> expectedDigestAlgorithm if arg is rfc5280.AlgorithmIdentifier
                fakeContext.key.withArgs('signedAttrs').returns
                    optional: ->
                        implicit: (arg) ->
                            if arg is 0
                                setof: (arg0) ->
                                    expectedSignedAttrs if arg0 is common.Attribute
                fakeContext.key.withArgs('signatureAlgorithm').returns
                    use: (arg) -> expectedSignatureAlgorithm if arg is rfc5280.AlgorithmIdentifier
                fakeContext.key.withArgs('signature').returns octstr: -> expectedSignature
                fakeContext.key.withArgs('unsignedAttrs').returns
                    optional: ->
                        implicit: (arg) ->
                            if arg is 1
                                setof: (arg0) -> expectedUnsignedAttrs if arg0 is common.Attribute

                result = bodyFn.call fakeContext

                expect(fakeContext.seq.calledTwice).to.be.true
                expect(objStub.obj.calledTwice).to.be.true
                expect(objStub.obj.calledWith(
                    expectedVersion
                    expectedSidResult
                    expectedDigestAlgorithm
                    expectedSignedAttrs
                    expectedSignatureAlgorithm
                    expectedSignature
                    expectedUnsignedAttrs
                )).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@SignerInfo).to.have.property 'decoders'
                expect(@SignerInfo.decoders).to.be.an 'object'
                expect(@SignerInfo.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@SignerInfo).to.have.property 'encoders'
                expect(@SignerInfo.encoders).to.be.an 'object'
                expect(@SignerInfo.encoders).to.empty


        describe 'CMSVersion', ->
            beforeEach ->
                @CMSVersion = timestampResponse.CMSVersion


            it 'is defined', ->
                expect(@CMSVersion).to.not.undefined


            it 'contains "name" property with correct value', ->
                expect(@CMSVersion).to.have.property 'name'
                expect(@CMSVersion.name).to.equal 'CMSVersion'


            it 'contains "body" property with provided callback', ->
                expect(@CMSVersion).to.have.property 'body'
                expect(@CMSVersion.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedResult = do Math.random
                bodyFn = @CMSVersion.body

                fakeContext = sinon.stub int: ->
                fakeContext.int.withArgs(0: 'v0', 1: 'v1', 2: 'v2', 3: 'v3', 4: 'v4', 5: 'v5').returns expectedResult
                result = bodyFn.call fakeContext

                expect(fakeContext.int.calledOnce).to.be.true
                expect(result).to.be.equal expectedResult


            it 'does not have any decoders', ->
                expect(@CMSVersion).to.have.property 'decoders'
                expect(@CMSVersion.decoders).to.be.an 'object'
                expect(@CMSVersion.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@CMSVersion).to.have.property 'encoders'
                expect(@CMSVersion.encoders).to.be.an 'object'
                expect(@CMSVersion.encoders).to.empty
