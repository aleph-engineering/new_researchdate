module.exports = ->
  'use strict'

  @Given /^I provide a encrypted_hash "([^"]*)"$/, (filename) ->
    @generalUpload('#verify-input', filename)
