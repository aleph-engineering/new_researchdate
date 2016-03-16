var myStepDefinitionsWrapper = function () {
    'use strict';

    this.Given(/^I provide the digital artifact$/, function () {
        browser.chooseFile('input[type="file"]', './tests/media/TEST.txt');
    });

    this.When(/^I click the button "([^"]*)"$/, function (name) {
        browser.click('');
    });


    this.Then(/^the site returns to me a timestamp$/, function () {
        callback.pending();
    });

    this.Then(/^returns the encrypted hash$/, function () {
        callback.pending();
    });
};

module.exports = myStepDefinitionsWrapper;