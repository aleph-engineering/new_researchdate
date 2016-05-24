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


        describe 'action method', ->
            beforeEach ->
                @meteorCallFn = sinon.stub Meteor, 'call'
                @expectedHash = '12311'

                @fakeContext =
                    request:
                        body:
                            hash: @expectedHash
                        method: 'POST'
                    response:
                        end: sinon.spy {end: (arg) -> 'good result' if arg instanceof Buffer}, 'end'
                        writeHead: sinon.stub {writeHead: ->}, 'writeHead'
                    render: ->
                @render = sinon.spy @fakeContext, 'render'

            afterEach ->
                do @meteorCallFn.restore
                do @render.restore


            it 'is defined', ->
                expect(@timestampController.action).not.to.be.undefined


            it "calls context's render method in case request method is not \'POST\'", ->
                @fakeContext.request.method = 'GET'

                @timestampController.action.call @fakeContext

                assert @render.calledOnce, 'Ensure to call \'this.render()\' when the request method is not \'POST\''


            it "calls Meteor.call('#{SERVER_TIMESTAMP}', ...) with the correct arguments if request method is \'POST\'", ->
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
