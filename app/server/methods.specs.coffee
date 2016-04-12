methodsModule = require './methods'


describe 'Server Methods module', ->
    it 'should be defined', ->
        expect(methodsModule).to.not.be.undefined

    describe 'saveTimestampRecord', ->
        beforeEach ->
            @saveTimestampRecord = methodsModule.saveTimestampRecord
            @insertMethod = sinon.spy Timestamps, 'insert'

        afterEach ->
            do @insertMethod.restore

        it 'should be defined', ->
            expect(@saveTimestampRecord).to.not.be.undefined

        it 'saves the correct information about the just made Timestamp', ->
            @saveTimestampRecord 'my_hash'

            lastCallArgs = @insertMethod.lastCall.args
            expect(lastCallArgs.length).to.equal 1
            newTimestamp = lastCallArgs[0]

            expect(newTimestamp).to.have.property('hash')
            expect(newTimestamp).to.have.property('creationDate')
            expect(newTimestamp).to.have.property('server')

            expect(newTimestamp.hash).to.equal 'my_hash'
            expect(newTimestamp.server).to.equal 'https://freetsa.org/'

            date = new Date()
            savedDate = newTimestamp.creationDate
            expect(savedDate.getHours()).to.equal date.getHours()
            expect(savedDate.getMinutes()).to.equal date.getMinutes()
            expect(savedDate.getDay()).to.equal date.getDay()
            expect(savedDate.getMonth()).to.equal date.getMonth()
            expect(savedDate.getYear()).to.equal date.getYear()
