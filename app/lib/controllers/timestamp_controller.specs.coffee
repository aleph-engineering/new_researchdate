timestampController = require './timestamp_controller'


describe 'TimestampController Module', ->
    it 'is defined', ->
        expect(timestampController).not.to.be.undefined


    describe 'TimestampController class', ->
        beforeEach ->
            @TimestampController = timestampController.TimestampController
            @timestampController = new @TimestampController()
            @fakeContext = sinon.stub
                next: ->


        describe 'onRun method', ->
            it 'is defined', ->
                expect(@timestampController.onRun).not.to.be.undefined


            it 'forwards execution to context\'s next function', ->
                @timestampController.onRun.call @fakeContext
                assert @fakeContext.next.calledOnce, 'Call to context\'s next function was not done!'


        describe 'onRerun method', ->
            it 'is defined', ->
                expect(@timestampController.onRerun).not.to.be.undefined


            it 'forwards execution to context\'s "next" function', ->
                @timestampController.onRerun.call @fakeContext
                assert @fakeContext.next.calledOnce, 'Call to context\'s "next" function was not done!'


        describe 'onBeforeAction method', ->
            it 'is defined', ->
                expect(@timestampController.onBeforeAction).not.to.be.undefined


            it 'if request is POST, it forwards execution to context\'s "next" function', ->
                fakeContext =
                    request:
                        method: 'POST'
                    next: sinon.spy {next: ->}, 'next'

                @timestampController.onBeforeAction.call fakeContext

                assert fakeContext.next.calledOnce, 'Call to context\'s "next" function was not done!'


            it 'if request is not POST, it ends response with 403 status code', ->
                fakeContext =
                    request:
                        method: 'GET'
                    response:
                        statusCode: undefined
                        end: sinon.spy {end: ->}, 'end'

                @timestampController.onBeforeAction.call fakeContext

                expect(fakeContext.response.statusCode).to.be.equal 403
                assert fakeContext.response.end.calledOnce, 'Request was not ended'
                assert(
                    fakeContext.response.end.calledWithExactly 'Not allowed'
                    'Request was not ended with correct message.'
                )
