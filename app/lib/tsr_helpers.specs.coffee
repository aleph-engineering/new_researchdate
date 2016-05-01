tsrHelpers = require './tsr_helpers'
tsResponse = require './asn1/timestamp_response'
rfc5280 = require 'asn1.js/rfc/5280'


expectMessageWhenMissingTimestampToken = (fn) ->
    expect(fn).to.throw 'Does not contain a timestamp'

expectMessageWhenMissingSignerInfos = (fn) ->
    expectErrorMessageWhenCalling fn, 'Does not contain a valid Signer Info'

expectErrorMessageWhenCalling = (fn, message) ->
    expect(fn).to.throw message

expectErrorTypeWhenCalling = (fn, type) ->
    expect(fn).to.throw type


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

        @createTSRWrapper = -> new tsrHelpers.TSRWrapper @tsaResponse


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
        beforeEach ->
            @responseStub.status.status = 'granted'
            @responseWithoutTSTStub.status.status = 'granted'

        it 'is defined', ->
            expect(tsrHelpers.TSRWrapper).not.to.be.undefined


        describe 'constructor method', ->
            it 'adds the decoded response as own field', ->
                tsrWrapper = @createTSRWrapper()
                expect(tsrWrapper.response).to.be.equal @responseStub

            it 'given no tsa response, throws an error', ->
                fn = -> new tsrHelpers.TSRWrapper undefined
                expect(fn).to.throw TypeError
                expect(fn).to.throw 'responseBuffer was not provided, please provide one'

            it "adds the tsa response encapsulated, already decoded, when the tsa response has the 'granted'", ->
                @responseStub.status.status = 'granted'
                @responseWithoutTSTStub.status.status = 'granted'
                tsrWrapper = @createTSRWrapper()
                expect(tsrWrapper.encapsulatedContent).to.be.equal @responseWithoutTSTStub.timeStampToken.content.encapContentInfo.eContent

            it "adds the tsa response encapsulated, already decoded, when the tsa response has the 'grantedWithMods'", ->
                @responseStub.status.status = 'grantedWithMods'
                @responseWithoutTSTStub.status.status = 'grantedWithMods'
                tsrWrapper = @createTSRWrapper()
                expect(tsrWrapper.encapsulatedContent).to.be.equal @responseWithoutTSTStub.timeStampToken.content.encapContentInfo.eContent

            it "adds the tsa response encapsulated, already decoded, when the tsa response has not either the 'grantedWithMods' or 'granted'", ->
                @responseStub.status.status = 'other status'
                @responseWithoutTSTStub.status.status = 'other status'
                tsrWrapper = @createTSRWrapper()
                expect(tsrWrapper.encapsulatedContent).to.be.undefined


        describe 'getHashHex method', ->
            it 'is defined', ->
                expect(@createTSRWrapper().getHashHex).not.to.be.undefined

            it 'returns a hexadecimal hash of the given response', ->
                expectedContent = messageImprint:
                    hashedMessage: 'bfac'
                tsrWrapper = @createTSRWrapper()
                getEncapsulatedContent = sinon.stub tsrWrapper, '_getEncapsulatedContent'
                getEncapsulatedContent.withArgs(tsrWrapper.response).returns expectedContent

                hashHex = tsrWrapper.getHashHex()

                expectedHashHex = new Buffer(expectedContent.messageImprint.hashedMessage).toString 'hex'
                expect(hashHex).to.be.equal expectedHashHex

                assert(
                    getEncapsulatedContent.calledOnce
                    'getEncapsulatedContent method was not called even once'
                )
                assert(
                    getEncapsulatedContent.calledWithExactly tsrWrapper.response
                    'getEncapsulatedContent method was not called with the correct arguments'
                )

                do getEncapsulatedContent.restore


        describe 'getSignature method', ->
            it 'is defined', ->
                expect(@createTSRWrapper().getSignature).not.to.be.undefined

            it "gets signature from response", ->
                tsrWrapper = @createTSRWrapper()
                signerInfo = signature: do Math.random
                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(tsrWrapper.response).returns signerInfo

                signature = tsrWrapper.getSignature()

                expect(signature).to.be.equal signerInfo.signature

                assert(
                    getSignerInfo.calledOnce
                    'getSignerInfo was not called even once'
                )
                assert(
                    getSignerInfo.calledWithExactly tsrWrapper.response
                    'getSignerInfo was not called with correct arguments'
                )

                do getSignerInfo.restore


        describe 'getPublicKey method', ->
            it 'is defined', ->
                expect(@createTSRWrapper().getPublicKey).not.to.be.undefined

            it "if there is a certificate in the TSA's response, gets public key from TSA's response signer info", ->
                tsrWrapper = @createTSRWrapper()
                signerDetails =
                    issuer: do Math.random
                    serialNumber: do Math.random
                issuerCertificate =
                    value:
                        tbsCertificate:
                            subjectPublicKeyInfo: do Math.random
                publicKeyInfo = issuerCertificate.value.tbsCertificate.subjectPublicKeyInfo
                timestampToken = certificates: do Math.random
                pem = do Math.random

                getSignerIssuerAndSerialNumber = sinon.stub tsrWrapper, '_getSignerIssuerAndSerialNumber'
                getSignerIssuerAndSerialNumber.withArgs(tsrWrapper.response).returns signerDetails
                getIssuerCertificate = sinon.stub tsrWrapper, '_getIssuerCertificate'
                getIssuerCertificate
                .withArgs(timestampToken.certificates, signerDetails.issuer, signerDetails.serialNumber)
                .returns issuerCertificate
                getTimestampToken = sinon.stub tsrWrapper, '_getTimestampToken'
                getTimestampToken.withArgs(tsrWrapper.response).returns timestampToken
                encode = sinon.stub rfc5280.SubjectPublicKeyInfo, 'encode'
                encode.withArgs(publicKeyInfo, 'pem', label: 'PUBLIC KEY').returns pem

                publicKey = tsrWrapper.getPublicKey()
                expect(publicKey).to.be.equal pem

                assert(
                    getSignerIssuerAndSerialNumber.calledOnce
                    'getSignerIssuerAndSerialNumber was not called even once'
                )
                assert(
                    getSignerIssuerAndSerialNumber.calledWithExactly tsrWrapper.response
                    'getSignerIssuerAndSerialNumber was not called with correct arguments'
                )

                assert(
                    getIssuerCertificate.calledOnce
                    'getIssuerCertificate was not called even once'
                )
                assert(
                    getIssuerCertificate.calledWithExactly(
                        timestampToken.certificates
                        signerDetails.issuer
                        signerDetails.serialNumber
                    )
                    'getIssuerCertificate was not called with correct arguments'
                )

                assert(
                    getTimestampToken.calledOnce
                    'getTimestampToken was not called even once'
                )
                assert(
                    getTimestampToken.calledWithExactly tsrWrapper.response
                    'getTimestampToken was not called with correct arguments'
                )

                assert(
                    encode.calledOnce
                    'encode was not called even once'
                )
                assert(
                    encode.calledWithExactly publicKeyInfo, 'pem', label: 'PUBLIC KEY'
                    'encode was not called with correct arguments'
                )

                do getSignerIssuerAndSerialNumber.restore
                do getIssuerCertificate.restore
                do getTimestampToken.restore
                do encode.restore

            it "if there is not a certificate in the TSA's response, returns null", ->
                tsrWrapper = @createTSRWrapper()
                signerDetails =
                    issuer: do Math.random
                    serialNumber: do Math.random
                timestampToken = certificates: do Math.random

                getSignerIssuerAndSerialNumber = sinon.stub tsrWrapper, '_getSignerIssuerAndSerialNumber'
                getSignerIssuerAndSerialNumber.withArgs(tsrWrapper.response).returns signerDetails
                getIssuerCertificate = sinon.stub tsrWrapper, '_getIssuerCertificate'
                getIssuerCertificate
                .withArgs(timestampToken.certificates, signerDetails.issuer, signerDetails.serialNumber)
                .returns undefined
                getTimestampToken = sinon.stub tsrWrapper, '_getTimestampToken'
                getTimestampToken.withArgs(tsrWrapper.response).returns timestampToken

                publicKey = tsrWrapper.getPublicKey()
                expect(publicKey).to.be.null

                do getSignerIssuerAndSerialNumber.restore
                do getIssuerCertificate.restore
                do getTimestampToken.restore


        describe 'getSignedContent method', ->
            it 'is defined', ->
                expect(@createTSRWrapper().getSignedContent).not.to.be.undefined

            it "TSA's response has not signed attributes, returns the TSRWrapper's encapsulated content", ->
                tsrWrapper = @createTSRWrapper()
                tsrWrapper.encapsulatedContent = do Math.random

                responseHasSignedAttrs = sinon.stub tsrWrapper, '_ensureResponseHasSignedAttrs'
                responseHasSignedAttrs.withArgs(tsrWrapper.response).returns no

                signedContent = tsrWrapper.getSignedContent()
                expect(signedContent).to.be.equal tsrWrapper.encapsulatedContent

                do responseHasSignedAttrs.restore

            it "TSA's response has signed attributes, returns encoded signed attributes using 'der'", ->
                tsrWrapper = @createTSRWrapper()
                signerInfo = signedAttrs: do Math.random
                encodedSignedAttrs = do Math.random

                responseHasSignedAttrs = sinon.stub tsrWrapper, '_ensureResponseHasSignedAttrs'
                responseHasSignedAttrs.withArgs(tsrWrapper.response).returns yes
                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(tsrWrapper.response).returns signerInfo
                encode = sinon.stub tsResponse.SignedAttributes, 'encode'
                encode.withArgs(signerInfo.signedAttrs, 'der').returns encodedSignedAttrs

                signedContent = tsrWrapper.getSignedContent()
                expect(signedContent).to.be.equal encodedSignedAttrs

                do responseHasSignedAttrs.restore
                do getSignerInfo.restore
                do encode.restore


        describe '_getEncapsulatedContent method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._getEncapsulatedContent).not.to.be.undefined

            it 'missing response argument, throws error', ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getEncapsulatedContent null
                expectErrorMessageWhenCalling fn, 'Missing response argument, please provide one'
                expectErrorTypeWhenCalling fn, Error

            it "given response, returns respnse timestamp token's encapsulated content", ->
                tsrWrapper = @createTSRWrapper()
                eContent = do Math.random
                expectedEncapsulatedContent = encapContentInfo:
                    eContent: eContent

                getTimestampToken = sinon.stub tsrWrapper, '_getTimestampToken'
                getTimestampToken.withArgs(tsrWrapper.response).returns expectedEncapsulatedContent

                encapsulatedContent = tsrWrapper._getEncapsulatedContent tsrWrapper.response
                expect(encapsulatedContent).to.be.equal eContent

                do getTimestampToken.restore


        describe '_getSignerInfo method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._getSignerInfo).not.to.be.undefined

            it 'throws Error, when not providing a response', ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getSignerInfo null
                expectErrorTypeWhenCalling fn, Error
                expectErrorMessageWhenCalling fn, 'Missing response argument, please provide one'

            it 'throws Error, when response has not signer info', ->
                tsrWrapper = @createTSRWrapper()

                ensureResponseHasSignerInfo = sinon.stub tsrWrapper, '_ensureResponseHasSignerInfo'
                ensureResponseHasSignerInfo.withArgs(tsrWrapper.response).throws new TypeError 'A'

                fn = -> tsrWrapper._getSignerInfo tsrWrapper.response
                expectErrorTypeWhenCalling fn, TypeError
                expectErrorMessageWhenCalling fn, /^A$/

                do ensureResponseHasSignerInfo.restore

            it 'returns first signer info given a correct response', ->
                tsrWrapper = @createTSRWrapper()
                timestampToken =
                    signerInfos: [do Math.random]

                ensureResponseHasSignerInfo = sinon.stub tsrWrapper, '_ensureResponseHasSignerInfo'
                getTimestampToken = sinon.stub tsrWrapper, '_getTimestampToken'
                getTimestampToken.
                withArgs(tsrWrapper.response).returns timestampToken

                signerInfo = tsrWrapper._getSignerInfo tsrWrapper.response

                expect(signerInfo).to.be.equal timestampToken.signerInfos[0]

                do ensureResponseHasSignerInfo.restore


        describe '_getSignerIssuerAndSerialNumber method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._getSignerIssuerAndSerialNumber).not.to.be.undefined

            it "throws Exception is not provided a TSA's response", ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getSignerIssuerAndSerialNumber null
                expectErrorTypeWhenCalling fn, Error
                expectErrorTypeWhenCalling fn, 'Missing response argument, please provide one'

            it "returns signer issuer and serial number if provided valid TSA's response", ->
                tsrWrapper = @createTSRWrapper()
                issuer = do Math.random
                serialNumber = do Math.random
                signerInfo =
                    sid:
                        value:
                            issuer: issuer
                            serialNumber: serialNumber
                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(tsrWrapper.response).returns signerInfo

                signerIssuerAndSerialNumber = tsrWrapper._getSignerIssuerAndSerialNumber tsrWrapper.response

                expect(signerIssuerAndSerialNumber.issuer).to.be.equal issuer
                expect(signerIssuerAndSerialNumber.serialNumber).to.be.equal serialNumber

                do getSignerInfo.restore


        describe '_getIssuerCertificate method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._getIssuerCertificate).not.to.be.undefined

            it 'throws Error if not provided certificates', ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getIssuerCertificate undefined
                expectErrorTypeWhenCalling fn, Error
                expect(fn).to.throw /^certificates were not provided$/

            it 'throws Error if not provided issuer', ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getIssuerCertificate [], undefined
                expectErrorTypeWhenCalling fn, Error
                expect(fn).to.throw /^issuer was not provided$/

            it 'throws Error if not provided serialNumber', ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getIssuerCertificate [], {}, undefined
                expectErrorTypeWhenCalling fn, Error
                expect(fn).to.throw /^serialNumber was not provided$/

            it 'gets the issuer certificate from the certificates and additional information provided, if finds one', ->
                tsrWrapper = @createTSRWrapper()
                certificates = []
                issuer = do Math.random
                serialNumber = do Math.random
                for i in [0..3]
                    certificates.push
                        value:
                            tbsCertificate:
                                issuer: if i is 1 then issuer else undefined
                                serialNumber: if i is 1 then serialNumber else undefined

                issuerCertificate = tsrWrapper._getIssuerCertificate certificates, issuer, serialNumber

                expect(issuerCertificate).to.be.eql certificates[1]

            it 'returns null if no issuer certificate is found from the certificates and additional information provided', ->
                tsrWrapper = @createTSRWrapper()
                certificates = []
                issuer = do Math.random
                serialNumber = do Math.random
                for i in [0..3]
                    certificates.push
                        value:
                            tbsCertificate:
                                issuer: do Math.random
                                serialNumber: do Math.random

                issuerCertificate = tsrWrapper._getIssuerCertificate certificates, issuer, serialNumber

                expect(issuerCertificate).to.be.null


        describe '_getTimestampToken', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._getTimestampToken).not.to.be.undefined

            it "throws Error, if not provided a TSA's response", ->
                tsrWrapper = @createTSRWrapper()
                fn = -> tsrWrapper._getTimestampToken null
                expectErrorTypeWhenCalling fn, Error
                expectErrorMessageWhenCalling fn, /^response was not provided$/

            it 'throws Error, if assertion of response status is invalid', ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                ensureResponseStatus = sinon.stub tsrWrapper, '_hasResponseStatus'
                ensureResponseStatus.withArgs(response).throws new Error 'A'
                fn = -> tsrWrapper._getTimestampToken response
                expectErrorTypeWhenCalling fn, Error
                expectErrorMessageWhenCalling fn, /^A$/

                do ensureResponseStatus.restore

            it 'returns correct token from the given response', ->
                tsrWrapper = @createTSRWrapper()
                response = timeStampToken:
                    content: do Math.random
                hasResponseStatus = sinon.stub tsrWrapper, '_hasResponseStatus'
                hasResponseStatus.withArgs(response).returns yes

                timestampToken = tsrWrapper._getTimestampToken response

                expect(timestampToken).to.be.equal response.timeStampToken.content


        describe '_ensureResponseHasSignedAttrs method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._ensureResponseHasSignedAttrs).not.to.be.undefined

            it 'returns true, if there is signer info in the given response', ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                signerInfo = signedAttrs: [{}]

                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(response).returns signerInfo

                result = tsrWrapper._ensureResponseHasSignedAttrs response

                expect(result).to.be.true

            it 'returns false, if there is not signer info in the given response', ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                signerInfo = signedAttrs: []

                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(response).returns signerInfo

                result = tsrWrapper._ensureResponseHasSignedAttrs response

                expect(result).to.be.false

            it 'returns false, if there is not signed attributes info in the given response', ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                signerInfo = {}

                getSignerInfo = sinon.stub tsrWrapper, '_getSignerInfo'
                getSignerInfo.withArgs(response).returns signerInfo

                result = tsrWrapper._ensureResponseHasSignedAttrs response

                expect(result).to.be.false


        describe '_hasResponseStatus method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._hasResponseStatus).not.to.be.undefined

            it "returns false if no response was provided", ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._hasResponseStatus undefined
                expect(result).to.be.false

            it "returns true if response has 'granted' status", ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                responseStatusIsGranted = sinon.stub tsrWrapper, '_responseStatusIsGranted'
                responseStatusIsGranted.withArgs(response).returns yes

                result = tsrWrapper._hasResponseStatus response

                expect(result).to.be.true

            it "returns true if response has 'grantedWithMods' status", ->
                tsrWrapper = @createTSRWrapper()
                response = do Math.random
                responseStatusIsGrantedWithMods = sinon.stub tsrWrapper, '_responseStatusIsGrantedWithMods'
                responseStatusIsGrantedWithMods.withArgs(response).returns yes

                result = tsrWrapper._hasResponseStatus response

                expect(result).to.be.true


        describe '_responseStatusIsGranted method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._responseStatusIsGranted).not.to.be.undefined

            it 'returns false when not given a response', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGranted undefined
                expect(result).to.be.false

            it 'returns false when not given a response without status', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGranted {}
                expect(result).to.be.false

            it 'returns false when not given a response without status in its status', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGranted status: undefined
                expect(result).to.be.false

            it "returns false when not given a response without 'granted' status in its status", ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGranted status:
                    status: undefined
                expect(result).to.be.false

            it "returns true when not given a response with 'granted' status in its status", ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGranted status:
                    status: 'granted'
                expect(result).to.be.true


        describe '_responseStatusIsGrantedWithMods method', ->
            it 'is defined', ->
                expect(@createTSRWrapper()._responseStatusIsGrantedWithMods).not.to.be.undefined

            it 'returns false when not given a response', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGrantedWithMods undefined
                expect(result).to.be.false

            it 'returns false when not given a response without status', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGrantedWithMods {}
                expect(result).to.be.false

            it 'returns false when not given a response without status in its status', ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGrantedWithMods status: undefined
                expect(result).to.be.false

            it "returns false when not given a response without 'grantedWithMods' status in its status", ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGrantedWithMods status:
                    status: undefined
                expect(result).to.be.false

            it "returns true when not given a response with 'grantedWithMods' status in its status", ->
                tsrWrapper = @createTSRWrapper()
                result = tsrWrapper._responseStatusIsGrantedWithMods status:
                    status: 'grantedWithMods'
                expect(result).to.be.true
