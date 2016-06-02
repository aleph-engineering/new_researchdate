module.exports = ->
    'use strict'

    @Given /^I am on the homepage$/, ->
        browser.url 'http://localhost:3000'

    @Given /^I am on the timestamp page$/, ->
        browser.url 'http://localhost:3000/timestamp'

    @Given /^I am on the verify tab$/, ->
        browser.url 'http://localhost:3000/timestamp#verify-tab'
