module.exports = ->
    'use strict'

    @Given /^exists some timestamps generated$/, ->
        data = [
            {hash: '67yut456ytgfg', creationDate: '5/1/2016', server: 'https://freetsa.org/'}
            {hash: '67yut45uioo6ytgfg', creationDate: '6/1/2016', server: 'https://freetsa.org/'}
            {hash: '67yut456lhgytgfg', creationDate: '7/1/2016', server: 'https://freetsa.org/'}
            {hash: '67yut456ythrrgfg', creationDate: '8/1/2016', server: 'https://freetsa.org/'}
            {hash: '67yut456ythrrgfg', creationDate: '9/1/2016', server: 'https://freetsa.org/'}
            {hash: '67yut456ythrrgfg', creationDate: '10/1/2016', server: 'https://freetsa.org/'}
        ]
        server.execute(((timestamps) -> Timestamps.insert(timestamp) for timestamp in timestamps), data)

    @Given /^not exist timestamps generated$/, ->
        server.execute(() -> Timestamps.remove({}))

    @Then /^I can see 10 timestamps in the timestamps list$/, ->
        timestamps = browser.getText 'table#timestamp-list tbody tr td.hash-cell'
        expect(timestamps.length).toBe 410

    @Then /^I can see there is not timestamps in the timestamps list$/, ->
        cantTr = browser.execute((-> $('#timestamp-list tbody tr')))
        expect(cantTr.value.length).toBe 0

    @Then /^they are ordered in descendant by date$/, ->
        TIMESTAMP_LIST_COUNT = require('../../../app/server/lib/system_parameters').TIMESTAMP_LIST_COUNT

        latestTimestamps = server.execute((count) ->
            Timestamps.find({},
                {
                    fields: {hash: yes, creationDate: yes},
                    sort: {creationDate: -1},
                    limit: count
                }
            ).fetch()
        , TIMESTAMP_LIST_COUNT)

        # Also expect the order of timestamps in the list is the expected
        browser.getText 'table#timestamp-list tbody tr td.hash-cell', (_, elements) ->
            for index, hashCell of elements
                expect(hashCell).toBe latestTimestamps[index].hash
