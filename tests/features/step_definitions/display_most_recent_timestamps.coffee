module.exports = ->
    'use strict'


    @And /^I timestamp the artifacts:$/, (scenario) ->
#        browser.waitForExist 'input[id="artifact"]', 3000

        # Make the timestamp request to each of the digital artifacts
        for data in scenario.rows()
            digital_artifact = data[0]

            # Upload the digital artifact
            browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
            browser.execute((-> $('input[type="file"]')[0].setAttribute('id', 'artifact')))
            #            browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'tsr')))
            browser.execute((-> $('input[type="file"]')[2].setAttribute('id', 'original')))
            browser.waitForExist 'input[id="artifact"]', 3000
            @generalUpload 'input[id="artifact"]', digital_artifact

            # Submit the form to timestamp
            browser.waitForExist '#artifact-form', 3000
            browser.submitForm '#artifact-form'


    @Then /^I should see until "(\d+)" timestamp records in the recent timestamps list$/, (count) ->
        browser.getText 'table#timestamp-list tbody tr td', (_, elements) ->
            expect(elements).not.toBe undefined, 'Expected timestamp records in the timestamp lists.'
            expect(elements.length).not.toBe 0, 'Expected timestamp records in the timestamp lists.'
            expect(elements.length / 3).toBeLessThan parseInt count + 1

            cursor = 0
            httpRegex = /(https?:\/\/(?:www\.|(?!www))[^\s\.]+\.[^\s]{2,}|www\.[^\s]+\.[^\s]{2,})/

            for element in elements
                if cursor is 0
                    expect(element).toMatch /^[a-f0-9]{1,128}$/
                else if cursor is 1
                    expect(Date.parse(element).toString()).not.toBe('NaN')
                else
                    expect(element).toMatch(httpRegex) if cursor is 2
                cursor = if cursor is 2 then 0 else cursor + 1


    @Then /^The recent timestamps list is as expected: it shows the last "(\d+)" timestamps ordered in descendant order by creation date$/, (timestampCount) ->
        TIMESTAMP_LIST_COUNT = require('../../../app/lib/system_parameters').TIMESTAMP_LIST_COUNT

        latestTimestamps = server.execute((count) ->
            Timestamps.find({},
                {
                    fields: {hash: yes, creationDate: yes},
                    sort: {creationDate: -1},
                    limit: count
                }
            ).fetch()
        , TIMESTAMP_LIST_COUNT)

        # Assert the timestamps count the expected quantity
        timestampCount = parseInt timestampCount
        expect(latestTimestamps.length).toBe timestampCount

        # Also expect the order of them in the list is the expected
        browser.getText 'table#timestamp-list tbody td.hash-cell', (_, elements) ->
            for index, hashCell of elements
                expect(hashCell).toBe latestTimestamps[index].hash
