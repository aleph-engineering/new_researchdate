module.exports = ->
  'use strict'

  @Given /^I provide the digital artifact "([^"]*)"$/, (filename) ->
    browser.chooseFile 'input[type="file"]', './tests/media/'.concat filename
