module.exports = ->
    'use strict'

    @Given /^I provide a encrypted hash "([^"]*)"$/, (filename) ->
        do pending
    #       Please do not commit not working steps, leave then in pending if not complete
    #        @generalUpload('#tsr-hash-input', filename)

    @And /^I provide the original artifact "([^"]*)"$/, (filename) ->
        do pending
    #        @generalUpload('#original-file-input', filename)

    @When /^I submit the verify form$/, ->
        do pending
    #        browser.submitForm '#verify-form'

    @Then /^I can see a message saying that the verification was successful$/, ->
        do pending
#        expect(browser.getValue('#result-input')).toBe 'Verification True'

