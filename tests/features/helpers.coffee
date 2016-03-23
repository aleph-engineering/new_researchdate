###*
# Created by marian on 3/16/16.
###

module.exports = ->
  'use strict'
  @Given /^I am on the homepage$/, ->
    browser.url 'http://localhost:3000'
