describe 'Timestamps Collection module', ->
    before ->
        @timestamps = require './timestamps'


    describe 'Timestamps Collection', ->
        beforeEach ->
            @Timestamps = @timestamps.Timestamps


        it 'is defined', ->
            expect(@Timestamps).to.not.be.undefined


        it 'is properly declared', ->
            expect(@Timestamps).to.be.instanceOf Mongo.Collection
