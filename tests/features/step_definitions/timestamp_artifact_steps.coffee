module.exports = ->
    'use strict'

    fs = require 'fs'
    _ = require 'underscore'


    isTimestampExtension = (file) ->
        timestampFileExtension = require('../../../app/lib/system_parameters').TIMESTAMP_FILE_EXTENSION
        file.slice(file.length - 4) is timestampFileExtension


    @And /^I provide a digital artifact$/, ->
#        browser.waitForExist '#original-artifact', 3000
#        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
#        browser.execute((-> $('input[type="file"]')[0].setAttribute('id', 'artifact')))
#        browser.pause 3000
#        browser.chooseFile ('input[id="artifact"]'), './tests/media/TEST.txt'
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.execute((-> $('input[type="file"]')[0].setAttribute('id', 'artifact')))
        #        browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'tsr')))
        #        browser.execute((-> $('input[type="file"]')[2].setAttribute('id', 'original')))
        browser.pause 3000
        browser.chooseFile 'input[id="artifact"]', './tests/media/TEST.txt'
        browser.pause 3000

    @When /^I submit the form$/, ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#artifact-form'

    @Then /^the site returns to me a timestamp$/, ->
        files = fs.readdirSync @downloadsFolder

        # Assert that there is .tsr file in the Downloads folder
        expect(_.any(files, isTimestampExtension)).toBeTruthy()

    @Then /^returns the encrypted hash$/, ->
        hashValue = browser.getValue '#hash'

        # Assert that there is currently a hash in the page, as result of the timestamping process
        expect(hashValue).toMatch /^[a-f0-9]{64}$/

    @Then /^the site return error$/, ->
