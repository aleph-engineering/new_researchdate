module.exports = ->
    'use strict'

    cellsSelector = 'table#timestamp-list tbody tr td'


    @Given /^I timestamp the artifacts:$/, (scenario) ->
        browser.waitForExist 'input[type="file"]', 3000

        # Make the timestamp request to each of the digital artifacts
        for data in scenario.rows()
            digital_artifact = data[0]

            # Upload the digital artifact
            browser.waitForExist '#generate-input', 3000
            @generalUpload '#generate-input', digital_artifact

            # Submit the form to timestamp
            browser.waitForExist '#artifact-form', 3000
            browser.submitForm '#artifact-form'


    @Then /^I should see until "(\d+)" timestamp records in the recent timestamps list$/, (count) ->
        browser.getText cellsSelector, (_, elements) ->
# Assert that there are actually listed timestamps
            expect(elements).not.toBe undefined, 'Expected timestamp records in the timestamp lists.'
            expect(elements.length / 2).toBeLessThan parseInt count + 1

            hashes = (x for i, x of elements when i % 2 isnt 1)
            dates = (x for i, x of elements when i % 2 is 1)

            # Assert that all the hashes of the timestamps follow the expected regular expression
            for hash in hashes
                expect(hash).toMatch /^[a-f0-9]{1,128}$/

            # Assert that all the dates are correct as well
            for date in dates
                expect(Date.parse(date).toString()).not.toBe 'NaN'


    @Then /^The recent timestamps list is as expected: it shows the last "(\d+)" timestamps ordered in descendant order by creation date$/, (timestampCount) ->
        latestTimestamps = server.execute ->
            Timestamps.find({},
                {
                    fields: {hash: yes, creationDate: yes},
                    sort: {creationDate: -1},
                    limit: SystemParameters.TIMESTAMP_LIST_COUNT
                }
            ).fetch()

        # Assert the timestamps count the expected quantity
        timestampCount = parseInt timestampCount
        expect(latestTimestamps.length).toBe timestampCount

        # Also expect the order of them in the list is the expected
        browser.getText 'table#timestamp-list tbody td.hash-cell', (_, elements) ->
            for index, hashCell of elements
                expect(hashCell).toBe latestTimestamps[index].hash
