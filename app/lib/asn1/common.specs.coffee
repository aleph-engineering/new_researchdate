asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'
common = require './common'


describe 'Common module', ->
    it 'is defined', ->
        expect(common).to.not.be.undefined


    describe 'ASN Models', ->
        describe 'MessageImprint', ->
            beforeEach ->
                @MessageImprint = common.MessageImprint


            it 'is defined', ->
                expect(@MessageImprint).to.not.be.undefined


            it 'contains "name" property with correct value', ->
                expect(@MessageImprint).to.have.property 'name'
                expect(@MessageImprint.name).to.equal 'MessageImprint'


            it 'contains "body" property with provided callback', ->
                expect(@MessageImprint).to.have.property 'body'
                expect(@MessageImprint.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedMessageImPrintBodyResult = do Math.random
                expectUseFnResult = do Math.random
                expectOctstrFnResult = do Math.random
                # Above were defined the expected results for the "use" and "octstr" methods, as well as the overall
                # MessageImprint.body function's result

                # Configuring the stubs that the MessageImprint.body function must interact with
                objFuncStub = sinon.stub obj: ->
                objFuncStub.obj.returns expectedMessageImPrintBodyResult
                useStub = sinon.stub use: ->
                useStub.use.withArgs(rfc5280.AlgorithmIdentifier).returns expectUseFnResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objFuncStub
                fakeContext.key.withArgs('hashAlgorithm').returns useStub
                fakeContext.key.withArgs('hashedMessage').returns octstr: -> expectOctstrFnResult

                callback = @MessageImprint.body
                result = callback.call fakeContext

                expect(result).to.be.equal expectedMessageImPrintBodyResult
                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objFuncStub.obj.calledOnce).to.be.true
                expect(objFuncStub.obj.firstCall.calledWith(expectUseFnResult, expectOctstrFnResult)).to.be.true


            it 'does not have any decoders', ->
                expect(@MessageImprint).to.have.property 'decoders'
                expect(@MessageImprint.decoders).to.be.an 'object'
                expect(@MessageImprint.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@MessageImprint).to.have.property 'encoders'
                expect(@MessageImprint.encoders).to.be.an 'object'
                expect(@MessageImprint.encoders).to.empty


        describe 'Any', ->
            before ->
                @Any = common.Any


            it 'is defined', ->
                expect(@Any).to.not.be.undefined


            it 'contains "name" property with correct value', ->
                expect(@Any).to.have.property 'name'
                expect(@Any.name).to.equal 'Any'


            it 'contains "body" property with provided callback', ->
                expect(@Any).to.have.property 'body'
                expect(@Any.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedAnyBodyFnResult = do Math.random
                fakeContext = sinon.stub
                    any: ->
                fakeContext.any.returns expectedAnyBodyFnResult

                callback = @Any.body
                result = callback.call fakeContext

                expect(fakeContext.any.calledOnce).to.be.true
                expect(result).to.be.equal expectedAnyBodyFnResult


            it 'does not have any decoders', ->
                expect(@Any).to.have.property 'decoders'
                expect(@Any.decoders).to.be.an 'object'
                expect(@Any.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@Any).to.have.property 'decoders'
                expect(@Any.encoders).to.be.an 'object'
                expect(@Any.encoders).to.empty


        describe 'Attribute', ->
            beforeEach ->
                @Attribute = common.Attribute


            it 'is defined', ->
                expect(@Attribute).to.not.be.undefined


            it 'contains "name" property with correct value', ->
                expect(@Attribute).to.have.property 'name'
                expect(@Attribute.name).to.equal 'Attribute'


            it 'contains "body" property with provided callback', ->
                expect(@Attribute).to.have.property 'body'
                expect(@Attribute.body).to.be.a 'Function'


            it '"body" callback does the right model configuration', ->
                expectedAttributeBodyFnResult = do Math.random
                expectedObjidFnResult = do Math.random
                expectedSetofFnResult = do Math.random
                # Same as before, initialing the expected result for the asn special methods: objid and setof and the
                # Attribute.body function's result also

                objFunc = sinon.stub obj: ->
                objFunc.obj.returns expectedAttributeBodyFnResult
                setofStub = sinon.stub setof: ->
                setofStub.setof.withArgs(common.Any).returns expectedSetofFnResult

                fakeContext = sinon.stub
                    seq: ->
                    key: ->
                fakeContext.seq.returns objFunc
                fakeContext.key.withArgs('attrType').returns objid: -> expectedObjidFnResult
                fakeContext.key.withArgs('attrValues').returns setofStub

                callback = @Attribute.body
                result = callback.call fakeContext

                expect(fakeContext.seq.calledOnce).to.be.true
                expect(objFunc.obj.calledOnce).to.be.true
                expect(objFunc.obj.calledWith expectedObjidFnResult, expectedSetofFnResult).to.be.true
                expect(result).to.be.equal expectedAttributeBodyFnResult


            it 'does not have any decoders', ->
                expect(@Attribute).to.have.property 'decoders'
                expect(@Attribute.decoders).to.be.an 'object'
                expect(@Attribute.decoders).to.empty


            it 'does not have any encoders', ->
                expect(@Attribute).to.have.property 'encoders'
                expect(@Attribute.encoders).to.be.an 'object'
                expect(@Attribute.encoders).to.empty


    describe 'PKCS7_CONTENT_TYPES', ->
        beforeEach ->
            @pkcs7 = common.PKCS7_CONTENT_TYPES


        it 'is defined', ->
            expect(@pkcs7).to.not.be.undefined


        it 'is be an object', ->
            expect(@pkcs7).to.be.an 'object'


        it 'should have a "data" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 1"
            expect(@pkcs7["1 2 840 113549 1 7 1"]).to.equal 'data'


        it 'should have a "signedData" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 2"
            expect(@pkcs7["1 2 840 113549 1 7 2"]).to.equal 'signedData'


        it 'should have a "envelopedData" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 3"
            expect(@pkcs7["1 2 840 113549 1 7 3"]).to.equal 'envelopedData'


        it 'should have a "signedAndEnvelopedData" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 4"
            expect(@pkcs7["1 2 840 113549 1 7 4"]).to.equal 'signedAndEnvelopedData'


        it 'should have a "digestData" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 5"
            expect(@pkcs7["1 2 840 113549 1 7 5"]).to.equal 'digestData'


        it 'should have a "encryptedData" value', ->
            expect(@pkcs7).to.have.property "1 2 840 113549 1 7 6"
            expect(@pkcs7["1 2 840 113549 1 7 6"]).to.equal 'encryptedData'
