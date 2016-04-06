queries = require './queries'
timestampsModule = require '../../lib/collections/timestamps'
Timestamps = timestampsModule.Timestamps


describe 'Queries object', ->
    it 'should be defined', ->
        expect(queries).to.not.be.undefined


    describe 'getLatestTimestamps', ->
        it 'should be defined', ->
            expect(queries.getLatestTimestamps).to.not.undefined

        it 'returns proper query, by calling correct Timestamps collection method with correct arguments', ->
# arrange
            findMethod = sinon.spy Timestamps, 'find'

            # act
            queries.getLatestTimestamps()

            # assert
            assert findMethod.calledOnce
            assert findMethod.calledWith {}, {sort: {creationDate: -1}}
