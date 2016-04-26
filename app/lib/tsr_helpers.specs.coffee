tsrHelpers = require './tsr_helpers'
tsResponse = require './asn1/timestamp_response'


describe 'TsrHelpers module', ->
    it 'is defined', ->
        expect(tsrHelpers).not.to.be.undefined


    describe 'getTSRWrapper', ->
        beforeEach ->
            @tsaResponse = 'ac'
            @responseStub =
                status:
                    status: do Math.random

            @trTSTDecode = sinon.stub tsResponse.TimestampResponseTST, 'decode'
            @trTSTDecode.withArgs(@tsaResponse, 'der').returns @responseStub


        afterEach ->
            do @trTSTDecode.restore


        it 'is defined', ->
            expect(tsrHelpers.getTSRWrapper).not.to.be.undefined


        it 'returns an instance of a TSRWrapper class', ->
            tsrWrapperObj = tsrHelpers.getTSRWrapper @tsaResponse
            expect(tsrWrapperObj).to.be.an.instanceOf tsrHelpers.TSRWrapper
            expect(tsrWrapperObj.response).to.be.equal @responseStub


    describe 'TSRWrapper class', ->
        it 'is defined', ->
            expect(tsrHelpers.TSRWrapper).not.to.be.undefined
