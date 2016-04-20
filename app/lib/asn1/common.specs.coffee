asn = require 'asn1.js'
rfc5280 = require 'asn1.js/rfc/5280'
common = require './common'


describe 'Common module', ->
    beforeEach ->
        @asnDefine = sinon.stub asn, 'define'

        class FakeContext
            any: => @
            seq: => @
            obj: => @
            key: => @
            use: => @
            octstr: => @
        @fakeContext = new FakeContext()
        @anyFuncSpy = sinon.spy @fakeContext, 'any'
        @seqFuncSpy = sinon.spy @fakeContext, 'seq'
        @objFuncSpy = sinon.spy @fakeContext, 'obj'
        @keyFuncSpy = sinon.spy @fakeContext, 'key'
        @useFuncSpy = sinon.spy @fakeContext, 'use'
        @octstrFuncSpy = sinon.spy @fakeContext, 'octstr'

    afterEach ->
        do @anyFuncSpy.restore
        do @seqFuncSpy.restore
        do @objFuncSpy.restore
        do @keyFuncSpy.restore
        do @useFuncSpy.restore
        do @octstrFuncSpy.restore
        do @asnDefine.restore


    it 'is defined', ->
        expect(common).to.not.be.undefined


    describe 'ASN Models', ->
        describe 'MessageImprint', ->
            before ->
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
                callback = @MessageImprint.body
                callback.call @fakeContext

                expect(@seqFuncSpy.calledOnce).to.be.true
                expect(@objFuncSpy.calledOnce).to.be.true
                expect(@keyFuncSpy.calledTwice).to.be.true
                expect(@keyFuncSpy.calledWith('hashAlgorithm')).to.be.true
                expect(@keyFuncSpy.calledWith('hashedMessage')).to.be.true
                expect(@useFuncSpy.calledWith(rfc5280.AlgorithmIdentifier)).to.be.true
                expect(@octstrFuncSpy.calledOnce).to.be.true

            it 'does not have any decoders', ->
                expect(@MessageImprint.decoders).to.be.an 'object'
                expect(@MessageImprint.decoders).to.empty

            it 'does not have any encoders', ->
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
                callback = @Any.body
                callback.call @fakeContext

                expect(@anyFuncSpy.calledOnce).to.be.true

            it 'does not have any decoders', ->
                expect(@Any.decoders).to.be.an 'object'
                expect(@Any.decoders).to.empty

            it 'does not have any encoders', ->
                expect(@Any.encoders).to.be.an 'object'
                expect(@Any.encoders).to.empty
