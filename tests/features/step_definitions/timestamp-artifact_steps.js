var myStepDefinitionsWrapper = function () {
    'use strict';


    this.Given(/^I provide the digital artifact "([^"]*)"$/, function (filename) {
        browser.chooseFile('input[type="file"]', './tests/media/'.concat(filename));
    });

    this.When(/^I submit the form$/, function () {
        browser.submitForm('#artifact-form');
    });

    this.Then(/^the site returns to me a timestamp$/, function () {
        pending();
    });

    this.Then(/^returns the encrypted hash$/, function () {
        pending();
    });
};

module.exports = myStepDefinitionsWrapper;