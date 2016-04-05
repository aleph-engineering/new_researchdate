require './timestamp_list'

timestampList = Template.TimestampList


describe 'Timestamp list template', ->
    it 'should be defined', ->
        expect(timestampList).to.not.be.undefined

    describe 'Helpers', ->
        it 'should have helpers description', ->
            expect(timestampList.helpers).to.not.be.undefined

        describe 'Latest timestamp: "latestTimestamps"', ->
            it 'should have latest timestamps helper', ->
                expect(timestampList.__helpers.has(' latestTimestamps')).to.be.true
            it 'should return latest timestamps', ->
