module.exports = ->
    'use strict'

    @And /^I provide a encrypted hash$/, ->
        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        #        browser.execute((-> $('input[type="file"]').css('width', '300px')))
        #        browser.execute((-> $('input[type="file"]').css('height', '100px')))
        browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'tsr')))
        browser.execute((-> $('input[type="file"]')[2].setAttribute('id', 'original')))
        browser.pause 3000
        browser.chooseFile('input[id="tsr"]', './tests/media/hash.tsr')
    #        @generalUpload 'input[id="tsr"]', './tests/media/hash.tsr'


    @And /^I provide the original artifact$/, ->
        browser.pause 3000
        #        @generalUpload 'input[id="original"]', './tests/media/TEST.txt'
        #        browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
        #        browser.execute((-> $('input[type="file"]').css('width', '300px')))
        #        browser.execute((-> $('input[type="file"]').css('height', '100px')))
        #        browser.execute((-> $('input[type="file"]')[1].setAttribute('id', 'tsr')))
        #        browser.execute((-> $('input[type="file"]')[2].setAttribute('id', 'original')))
        #        browser.pause 3000
        #        @generalUpload 'input[id="original"]', './tests/media/hash.tsr'
        browser.chooseFile 'input[id="original"]', './tests/media/TEST.txt'

    @When /^I submit the verify form$/, ->
#        browser.waitForExist '#verify-form', 3000
        browser.pause 3000
        browser.submitForm '#verify-form'

    @Then /^I can see a message saying that the verification was successful$/, ->
        expect(browser.getValue('#result-input')).toBe 'Verification True'

