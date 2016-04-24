timestampController = require './timestamp_controller'

SERVER_TIMESTAMP = 'server/timestamp'


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


        describe 'action method', ->
            beforeEach ->
                @meteorCallFn = sinon.stub Meteor, 'call'
                @expectedHash = '12311'
                @fakeContext =
                    request:
                        body:
                            hash: @expectedHash
                    response:
                        end: sinon.spy {end: (arg) -> 'good result' if arg instanceof Buffer}, 'end'
                        writeHead: sinon.stub {writeHead: ->}, 'writeHead'

            afterEach ->
                do @meteorCallFn.restore


            it 'is defined', ->
                expect(@timestampController.action).not.to.be.undefined


            it "calls Meteor.call('#{SERVER_TIMESTAMP}', ...) with the correct arguments", ->
                @timestampController.action.call @fakeContext

                assert @meteorCallFn.calledOnce, "Never was made the actual Meteor.call('#{SERVER_TIMESTAMP}', ...)"
                assert @meteorCallFn.calledWith(SERVER_TIMESTAMP, @expectedHash), 'Invalid Meteor.Call arguments!'
                expect(@meteorCallFn.args[0][2]).to.be.a 'function'


            it 'if calls Meteor.call and an error occurs, it logs it to the console', ->
                error = new Error 'expected error'
                @meteorCallFn.onFirstCall().callsArgWith 2, error
                consoleLog = sinon.stub console, 'log'

                @timestampController.action.call @fakeContext

                assert consoleLog.calledTwice, 'console.log was not called twice'
                expect(consoleLog.args[0][0]).to.be.equal 'Occurred an error in the process!! Details below:'
                expect(consoleLog.args[1][0]).to.be.equal error
                do consoleLog.restore


            it 'if no error, ends the response with the content of the result timestamp file', ->
                responseResult = 1: 'a', 2: 'b', 3: 'c'
                @meteorCallFn.onFirstCall().callsArgWith 2, null, responseResult
                expectedHeaders =
                    'Content-Type': 'application/timestamp-reply',
                    'Content-Disposition': "attachment; filename=hash.tsr"

                @timestampController.action.call @fakeContext

                resultBuffer = @fakeContext.response.end.args[0][0]
                expectedBuffer = new Buffer Object.keys(responseResult).map (key) -> responseResult[key]
                assert(
                    @fakeContext.response.writeHead.calledWith 200, expectedHeaders
                    'Response headers were not set.'
                )
                expect(resultBuffer).to.be.instanceOf Buffer
                expect(resultBuffer.length).to.be.equals expectedBuffer.length
