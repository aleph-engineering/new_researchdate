/**
 * Created by marian on 3/16/16.
 */
module.exports = function () {
    'use strict';

    this.Given(/^I am on the homepage$/, function () {
        browser.url('http://localhost:3000');
    });

};