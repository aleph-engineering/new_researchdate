rfc5280 = require 'asn1.js/rfc/5280'
timestampRequest = require './timestamp_request'
commonSpecs = require './common.specs'
common = require './common'


describe 'TimestampRequest module', ->
    it 'is defined', ->
        expect(timestampRequest).to.not.be.undefined


    describe 'TimestampRequest ASN Model', ->
        beforeEach ->
            @fakeContext = new commonSpecs.FakeContext()
            @TimestampRequest = timestampRequest.TimestampRequest

            @seqFuncSpy = sinon.spy @fakeContext, 'seq'
            @objFuncSpy = sinon.spy @fakeContext, 'obj'
            @keyFuncSpy = sinon.spy @fakeContext, 'key'

            @intFuncSpy = sinon.spy @fakeContext, 'int'
            @useFuncSpy = sinon.spy @fakeContext, 'use'
            @optionalFuncSpy = sinon.spy @fakeContext, 'optional'
            @objidFuncSpy = sinon.spy @fakeContext, 'objid'
            @defFuncSpy = sinon.spy @fakeContext, 'def'
            @boolFuncSpy = sinon.spy @fakeContext, 'bool'
            @implicitFuncSpy = sinon.spy @fakeContext, 'implicit'
            @seqofFuncSpy = sinon.spy @fakeContext, 'seqof'


        afterEach ->
            do @seqFuncSpy.restore
            do @objFuncSpy.restore
            do @keyFuncSpy.restore
            do @intFuncSpy.restore
            do @useFuncSpy.restore
            do @optionalFuncSpy.restore
            do @objidFuncSpy.restore
            do @defFuncSpy.restore
            do @boolFuncSpy.restore
            do @implicitFuncSpy.restore
            do @seqofFuncSpy.restore


        it 'is defined', ->
            expect(@TimestampRequest).to.not.be.undefined


        it 'contains "name" property with correct value', ->
            expect(@TimestampRequest).to.have.property 'name'
            expect(@TimestampRequest.name).to.equal 'TimestampRequest'


        it 'contains "body" property with provided callback', ->
            expect(@TimestampRequest).to.have.property 'body'
            expect(@TimestampRequest.body).to.be.a 'Function'


        it '"body" callback does the right model configuration', ->
            callback = @TimestampRequest.body
            callback.call @fakeContext

            expect(@seqFuncSpy.calledOnce).to.be.true

            expect(@objFuncSpy.calledOnce).to.be.true

            expect(@keyFuncSpy.callCount).to.equal 6
            expect(@keyFuncSpy.calledWith 'version').to.be.true
            expect(@keyFuncSpy.calledWith 'messageImprint').to.be.true
            expect(@keyFuncSpy.calledWith 'reqPolicy').to.be.true
            expect(@keyFuncSpy.calledWith 'nonce').to.be.true
            expect(@keyFuncSpy.calledWith 'certReq').to.be.true
            expect(@keyFuncSpy.calledWith 'extensions').to.be.true

            expect(@intFuncSpy.calledWith 1: 'v1').to.be.true
            expect(@intFuncSpy.calledWith()).to.be.true

            expect(@useFuncSpy.calledWith common.MessageImprint).to.be.true
            expect(@optionalFuncSpy.callCount).to.be.equal 3
            expect(@optionalFuncSpy.firstCall.calledWith()).to.be.true
            expect(@optionalFuncSpy.secondCall.calledWith()).to.be.true
            expect(@optionalFuncSpy.thirdCall.calledWith()).to.be.true
            expect(@objidFuncSpy.calledOnce).to.be.true
            expect(@defFuncSpy.calledWith no).to.be.true
            expect(@boolFuncSpy.calledWith()).to.be.true
            expect(@implicitFuncSpy.calledWith 0).to.be.true
            expect(@seqofFuncSpy.calledWith rfc5280.Extension).to.be.true


        it 'does not have any decoders', ->
            expect(@TimestampRequest).to.have.property 'decoders'
            expect(@TimestampRequest.decoders).to.be.an 'object'
            expect(@TimestampRequest.decoders).to.empty


        it 'does not have any encoders', ->
            expect(@TimestampRequest).to.have.property 'encoders'
            expect(@TimestampRequest.encoders).to.be.an 'object'
            expect(@TimestampRequest.encoders).to.empty
