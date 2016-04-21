module.exports = ->
    'use strict'

    @Given /^I provide a encrypted hash "([^"]*)"$/, (filename) ->
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        browser.execute((-> $('input[type="file"]').css('width', '300px')))
        browser.execute((-> $('input[type="file"]').css('height', '100px')))
        browser.element('#tsr-hash').getValue()
    #        @generalUpload('div#tsr-hash input[type="file"]', filename)
    #        @generalUpload('#tsr-hash-input', filename)

    @And /^I provide the original artifact "([^"]*)"$/, (filename) ->
        @generalUpload('#original-file-input', filename)

    @When /^I submit the verify form$/, ->
        browser.submitForm '#verify-form'

    @Then /^I can see a message saying that the verification was successful$/, ->
        expect(browser.getValue('#result-input')).toBe 'Verification True'

