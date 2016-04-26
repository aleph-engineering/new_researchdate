tsrHelpers = require './tsr_helpers'
tsResponse = require './asn1/timestamp_response'


describe 'TsrHelpers module', ->
    beforeEach ->
        @tsaResponse = 'ac'
        @responseStub =
            status:
                status: do Math.random
            timeStampToken:
                content:
                    encapContentInfo:
                        eContent: do Math.random
        @responseWithoutTSTStub =
            status:
                status: do Math.random
            timeStampToken:
                content:
                    encapContentInfo:
                        eContent: do Math.random

        @trTSTDecode = sinon.stub tsResponse.TimestampResponseTST, 'decode'
        @trTSTDecode.withArgs(@tsaResponse, 'der').returns @responseStub

        @trTRDecode = sinon.stub tsResponse.TimestampResponse, 'decode'
        @trTRDecode.withArgs(@tsaResponse, 'der').returns @responseWithoutTSTStub


    afterEach ->
        do @trTSTDecode.restore
        do @trTRDecode.restore


    it 'is defined', ->
        expect(tsrHelpers).not.to.be.undefined


    describe 'getTSRWrapper', ->
        it 'is defined', ->
            expect(tsrHelpers.getTSRWrapper).not.to.be.undefined

        it 'returns an instance of a TSRWrapper class', ->
            tsrWrapperObj = tsrHelpers.getTSRWrapper @tsaResponse
            expect(tsrWrapperObj).to.be.an.instanceOf tsrHelpers.TSRWrapper
            expect(tsrWrapperObj.response).to.be.equal @responseStub


    describe 'TSRWrapper class', ->
        it 'is defined', ->
            expect(tsrHelpers.TSRWrapper).not.to.be.undefined


        describe 'constructor method', ->
            it 'adds the decoded response as own field', ->
                tsrWrapper = new tsrHelpers.TSRWrapper @tsaResponse
                expect(tsrWrapper.response).to.be.equal @responseStub

            it 'given no tsa response, throws an error', ->
                fn = -> new tsrHelpers.TSRWrapper undefined
                expect(fn).to.throw TypeError
                expect(fn).to.throw 'responseBuffer was not provided, please provide one'

            it "adds the tsa response encapsulated, already decoded, when the tsa response has the 'granted'", ->
                @responseStub.status.status = 'granted'
                @responseWithoutTSTStub.status.status = 'granted'
                tsrWrapper = new tsrHelpers.TSRWrapper @tsaResponse
                expect(tsrWrapper.encapsulatedContent).to.be.equal @responseWithoutTSTStub.timeStampToken.content.encapContentInfo.eContent

            it "adds the tsa response encapsulated, already decoded, when the tsa response has the 'grantedWithMods'", ->
                @responseStub.status.status = 'grantedWithMods'
                @responseWithoutTSTStub.status.status = 'grantedWithMods'
                tsrWrapper = new tsrHelpers.TSRWrapper @tsaResponse
                expect(tsrWrapper.encapsulatedContent).to.be.equal @responseWithoutTSTStub.timeStampToken.content.encapContentInfo.eContent

            it "adds the tsa response encapsulated, already decoded, when the tsa response has not either the 'grantedWithMods' or 'granted'", ->
                @responseStub.status.status = 'other status'
                @responseWithoutTSTStub.status.status = 'other status'
                tsrWrapper = new tsrHelpers.TSRWrapper @tsaResponse
                expect(tsrWrapper.encapsulatedContent).to.be.undefined
