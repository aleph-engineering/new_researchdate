module.exports = ->
    'use strict'

    fs = require 'fs'
    _ = require 'underscore'


    # Build the absolute path the Downloads folder of the current user profile, where is supposed to be downloaded the
    # generated file. NOTE: that is the browser used for the tests must have this route as the default downloads folder,
    # otherwise the test won't work.
    DOWNLOADS_FOLDER = (process.env.HOME || process.env.USERPROFILE).concat '/Downloads'


    isTimestampExtension = (file) ->
        timestampFileExtension = server.execute -> SystemParameters.TIMESTAMP_FILE_EXTENSION
        file.slice(file.length - 4) is timestampFileExtension


    @Given /^I provide the digital artifact "([^"]*)"$/, (filename) ->
        browser.waitForExist '#generate-input', 3000
        @generalUpload('#generate-input', filename)

    @When /^I submit the form$/, ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#artifact-form'
        browser.pause 300

    @Then /^the site returns to me a timestamp$/, ->
        files = fs.readdirSync @downloadsFolder

        # Assert that there is .tsr file in the Downloads folder
        expect(_.any(files, isTimestampExtension)).toBeTruthy()

    @Then /^returns the encrypted hash$/, ->
        hashValue = browser.getValue '#hash'

        # Assert that there is currently a hash in the page, as result of the timestamping process
        expect(hashValue).toMatch /^[a-f0-9]{64}$/
