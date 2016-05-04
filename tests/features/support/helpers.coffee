module.exports = ->
    'use strict'

    @Given /^I am on the homepage$/, ->
        browser.url 'http://localhost:3000'


    @Given /^I wait (\d+) seconds$/, (seconds) ->
        browser.pause seconds * 1000
