timestamping = require './timestamping'


describe 'Timestamping Module', ->
    it 'is defined', ->
        expect(timestamping).to.not.be.undefined

    describe '_buildTimestampRequestOptions Method', ->
        beforeEach ->
            @_buildTimestampRequestOptions = timestamping._buildTimestampRequestOptions

        it 'is defined', ->
            expect(@_buildTimestampRequestOptions).to.not.be.undefined
