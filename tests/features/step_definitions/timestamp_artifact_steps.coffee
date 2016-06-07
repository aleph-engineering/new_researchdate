module.exports = ->
    'use strict'

    fs = require 'fs'
    _ = require 'underscore'


    isTimestampExtension = (file) ->
        timestampFileExtension = require('../../../app/server/lib/system_parameters').TIMESTAMP_FILE_EXTENSION
        file.slice(file.length - 4) is timestampFileExtension

    isZipExtension = (file) ->
        file.slice(file.length - 4) is '.zip'

    clickTimestampButton = ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#artifact-form'

    @And /^I provide a valid digital artifact$/, ->
        do @setIdToInput
        browser.chooseFile 'input[id="file"]', './tests/media/TEST.txt'

    @When /^I provide a digital artifact bigger than 256 MB$/, ->
        do @setIdToInput
        browser.chooseFile 'input[id="file"]', './tests/media/file512.txt'

    @When /^I submit the form$/, ->
        do clickTimestampButton

    @Then /^the site returns to me a zip file containing the timestamp$/, ->
        files = fs.readdirSync @downloadsFolder

        # Assert that there is .tsr file in the Downloads folder
        expect(_.any(files, isZipExtension)).toBeTruthy()

    @When /^I submit the timestamp empty form$/, ->
        do clickTimestampButton

    @When /^I can see the require areas focused$/, ->
        browser.waitForExist '.dropzone.dz-clickable.error', 5000
