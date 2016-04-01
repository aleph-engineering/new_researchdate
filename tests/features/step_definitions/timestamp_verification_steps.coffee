module.exports = ->
    'use strict'

    @And = @Given

    @Given /^I provide a encrypted hash "([^"]*)"$/, (filename) ->
        @generalUpload('#tsr-hash-input', filename)

    @And /^I provide the original artifact "([^"]*)"$/, (filename) ->
        @generalUpload('#original-file-input', filename)

    @When /^I submit the verify form$/, ->
        browser.submitForm '#verify-form'

    @Then /^I can see a message saying that the verification was successful$/, ->
        expect(browser.getValue('#result-input')).toBe 'Verification True'

