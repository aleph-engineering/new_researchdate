module.exports = ->
    'use strict'

    fs = require 'fs'
    _ = require 'underscore'


    isTimestampExtension = (file) ->
        timestampFileExtension = require('../../../app/lib/system_parameters').TIMESTAMP_FILE_EXTENSION
        file.slice(file.length - 4) is timestampFileExtension


    @Given /^I provide the digital artifact "([^"]*)"$/, (filename) ->
#        browser.waitForExist '#original-artifact', 3000
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.execute((-> $('input[type="file"]').css('width', '300px')))
        browser.execute((-> $('input[type="file"]').css('height', '100px')))
        browser.pause 3000
    #        @generalUpload('div#original-artifact input[type="file"]', filename)
    #        browser.pause 3000
    #        browser.setValue('#hash', '685c01d82443e1ca6283a29ac0b693fec50ecaf92ecb82e31b6b3817c52a85ca')
    #        browser.click("#original-artifact").uploadFile('./tests/media/TEST.txt')

    @When /^I submit the form$/, ->
#        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#artifact-form'
    #        browser.pause 300

    @Then /^the site returns to me a timestamp$/, ->
        files = fs.readdirSync @downloadsFolder

        # Assert that there is .tsr file in the Downloads folder
        expect(_.any(files, isTimestampExtension)).toBeTruthy()

    @Then /^returns the encrypted hash$/, ->
        hashValue = browser.getValue '#hash'

        # Assert that there is currently a hash in the page, as result of the timestamping process
        expect(hashValue).toMatch /^[a-f0-9]{64}$/
