SystemParameters = require './lib/system_parameters'
timestampsCollection = require '../lib/collections/timestamps'
publishModule = require '../server/publish'

Timestamps = timestampsCollection.Timestamps
makePublications = publishModule.makePublications


describe 'Publications', ->
    beforeEach ->
        @publishSpy = sinon.spy Meteor, 'publish'
        @timestampsFindSpy = sinon.spy Timestamps, 'find'

        do makePublications

    afterEach ->
        do @publishSpy.restore
        do @timestampsFindSpy.restore

    describe 'latestTimestamps', ->
        it 'should be defined', ->
            assert @publishSpy.calledWith 'latestTimestamps'

        it 'got referenced a correct function', ->
# arrange
            queryFunction = @publishSpy.args[0][1]
            # act
            do queryFunction
            # assert
            assert @timestampsFindSpy.calledWith({})
