module.exports = ->
    'use strict'

    @And /^I provide a valid zip file$/, ->
        do addIdToInput
        browser.chooseFile('input[id="zipVerification"]', './tests/media/TEST.zip')

    @When /^I submit the verify form$/, ->
        do clickVerifyButton

    @Then /^I can see a message saying that the verification was successful$/, ->
        browser.waitForExist '.toast-info', 3000
        expect(browser.getText('.toast-info')).toBe 'Verification Successful'

    @Then /^I can see a message saying that the verification was unsuccessful$/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'Verification Failed'

    @And /^I provide a invalid zip file$/, ->
        do addIdToInput
        browser.chooseFile 'input[id="zipVerification"]', './tests/media/invalid.zip'

    @When /^I submit the verify empty form$/, ->
        do clickVerifyButton

    clickVerifyButton = ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#verify-form'

    addIdToInput = ->
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.waitForExist 'input[type="file"]', 3000
        browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'zipVerification')))

    @And /^I provide a zip file that does not contain .tsr file$/, ->
        do addIdToInput
        browser.chooseFile('input[id="zipVerification"]', './tests/media/not_tsr.zip')

    @Then /^I can see a message saying that zip does not contain a timestamp file/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'The zip does not contain a timestamp file (.tsr)'

    @And /^I provide a zip file that does not contain a timestamped file/, ->
        do addIdToInput
        browser.chooseFile('input[id="zipVerification"]', './tests/media/only_tsr.zip')

    @Then /^I can see a message saying that does not contain a timestamped file/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'The zip does not contain a timestamped file'
