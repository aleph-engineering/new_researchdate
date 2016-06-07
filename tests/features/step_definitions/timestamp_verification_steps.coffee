module.exports = ->
    'use strict'

    @And /^I provide a valid zip file$/, ->
        do @setIdToInput
        browser.chooseFile('input[id="file"]', './tests/media/TEST.zip')

    @When /^I submit the verify form$/, ->
        do clickVerifyButton

    @Then /^I can see a message saying that the verification was successful$/, ->
        browser.waitForExist '.toast-info', 5000
        expect(browser.getText('.toast-info')).toBe 'Verification Successful'

    @Then /^I can see a message saying that the verification was unsuccessful$/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'Verification Failed'

    @And /^I provide a invalid zip file$/, ->
        do @setIdToInput
        browser.chooseFile 'input[id="file"]', './tests/media/invalid.zip'

    @When /^I submit the verify empty form$/, ->
        do clickVerifyButton

    clickVerifyButton = ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#verify-form'

    @And /^I provide a zip file that does not contain .tsr file$/, ->
        do @setIdToInput
        browser.chooseFile('input[id="file"]', './tests/media/not_tsr.zip')

    @Then /^I can see a message saying that zip does not contain a timestamp file/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'The zip does not contain a timestamp file (.tsr)'

    @And /^I provide a zip file that does not contain a timestamped file/, ->
        do @setIdToInput
        browser.chooseFile('input[id="file"]', './tests/media/only_tsr.zip')

    @Then /^I can see a message saying that does not contain a timestamped file/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'The zip does not contain a timestamped file'
