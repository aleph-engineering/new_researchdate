module.exports = ->
    'use strict'

    fs = require 'fs'
    _ = require 'underscore'


    isTimestampExtension = (file) ->
        timestampFileExtension = require('../../../app/lib/system_parameters').TIMESTAMP_FILE_EXTENSION
        file.slice(file.length - 4) is timestampFileExtension

    clickTimestampButton = ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#artifact-form'

    @And /^I provide a digital artifact$/, ->
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.execute((-> $('input[type="file"]')[0].setAttribute('id', 'artifact')))
        browser.chooseFile 'input[id="artifact"]', './tests/media/TEST.txt'

    @When /^I submit the form$/, ->
        do clickTimestampButton

    @Then /^the site returns to me a timestamp$/, ->
        files = fs.readdirSync @downloadsFolder

        # Assert that there is .tsr file in the Downloads folder
        expect(_.any(files, isTimestampExtension)).toBeTruthy()

    @Then /^returns the encrypted hash$/, ->
        hashValue = browser.getValue '#hash'

        # Assert that there is currently a hash in the page, as result of the timestamping process
        expect(hashValue).toMatch /^[a-f0-9]{64}$/

    @When /^I submit the timestamp empty form$/, ->
        do clickTimestampButton

    @When /^I can see the require areas focused$/, ->
        browser.waitForExist '.dropzone.dz-clickable.error', 3000

    @Then /^no returns the encrypted hash$/, ->
        hashValue = browser.getValue '#hash'

        # Assert that there is not a hash in the page
        expect(hashValue).toBe 'NONE'
