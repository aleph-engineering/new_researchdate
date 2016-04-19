methods = require './methods'
timestamping = require './lib/timestamping'


describe 'Methods module', ->
    beforeEach ->
        @meteorStub = sinon.stub Meteor, 'methods'
        do methods.registerMethods

    afterEach ->
        do @meteorStub.restore


    it 'called Meteor.methods method', ->
        assert @meteorStub.calledOnce


    describe 'server/timestamp method', ->
        beforeEach ->
            ### Fake the timestamp generator factory function in timestamping module ###
            @methodsConfig = @meteorStub.args[0][0]
            @fakeTimestampGenerator = sinon.stub timestamp: () ->
            @getTimestampGenerator = sinon.stub timestamping, 'getTimestampGenerator'
            @getTimestampGenerator.returns @fakeTimestampGenerator

            @callServerTimestampMethod = (hash) ->
                method = @methodsConfig['server/timestamp']
                context = sinon.stub unblock: ->
                method.call context, hash # Fake the context in which the function is called
                context

        afterEach ->
            do @getTimestampGenerator.restore

        it 'is registered', ->
            expect(@methodsConfig).to.have.property 'server/timestamp'


        it 'server/timestamp method does not block request execution', ->
            context = @callServerTimestampMethod '123'
            expect(context.unblock.calledOnce).to.be.true


        it 'executes proper timestamping logic', ->
            hash = '1'

            @callServerTimestampMethod hash

            expect(@fakeTimestampGenerator.timestamp.calledOnce).to.be.true
            expect(@fakeTimestampGenerator.timestamp.calledWith(hash)).to.be.true
