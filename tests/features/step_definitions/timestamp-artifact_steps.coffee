myStepDefinitionsWrapper = ->
  'use strict'
  @Given /^I provide the digital artifact "([^"]*)"$/, (filename) ->
    browser.chooseFile 'input[type="file"]', './tests/media/'.concat(filename)

  @When /^I submit the form$/, ->
    browser.submitForm '#artifact-form'

  @Then /^the site returns to me a timestamp$/, ->
    pending()

  @Then /^returns the encrypted hash$/, ->
    pending()

module.exports = myStepDefinitionsWrapper
