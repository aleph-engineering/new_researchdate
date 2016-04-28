module.exports = ->
    'use strict'

    @And /^I provide a valid tsr file$/, ->
        do addIdToInput
        browser.chooseFile('input[id="tsr"]', './tests/media/valid.tsr')


    @And /^I provide the original file$/, ->
        browser.pause 3000
        browser.chooseFile 'input[id="original"]', './tests/media/TEST.txt'

    @When /^I submit the verify form$/, ->
        do clickVerifyButton

    @Then /^I can see a message saying that the verification was successful$/, ->
        browser.waitForExist '.toast-info', 3000
        expect(browser.getText('.toast-info')).toBe 'Verification Successful'

    @Then /^I can see a message saying that the verification was unsuccessfu$/, ->
        browser.waitForExist '.toast-error', 3000
        expect(browser.getText('.toast-error')).toBe 'Verification Failed'

    @And /^I provide a invalid tsr file$/, ->
        do addIdToInput
        browser.chooseFile 'input[id="tsr"]', './tests/media/invalid.tsr'

    @When /^I submit the verify empty form$/, ->
        do clickVerifyButton

    clickVerifyButton = ->
        browser.waitForExist '#artifact-form', 3000
        browser.submitForm '#verify-form'

    addIdToInput = ->
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'tsr')))
        browser.execute((-> $('input[type="file"]')[2].setAttribute('id', 'original')))
