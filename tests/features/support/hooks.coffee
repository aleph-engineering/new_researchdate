module.exports = ->
    clearServer = ->
        server.execute ->
            Timestamps.remove {}

    @And = @Given

    @Before ->
        do clearServer

        ### This will be executed each time the e2e tests are executed ###
        @userProfileFolder = process.env.HOME || process.env.USERPROFILE
        @downloadsFolder = @userProfileFolder.concat '/Downloads'

        @setIdToInput = ->
            browser.execute((-> $('input[type="file"]').css('visibility', 'visible')))
            browser.waitForExist 'input[type="file"]', 3000
            browser.execute((-> $('input[type="file"]')[0].setAttribute('id', 'file')))

    @After ->
        do clearServer

        ### This will be executed each time the e2e tests are executed ###
        fs = require 'fs'

        downloadsFolder = @downloadsFolder

        # Remove all the .tsr files
        fs.readdirSync(@downloadsFolder).forEach (file) ->
            if file.slice(file.length - 4) is '.tsr'
                fileAbsolutePath = downloadsFolder.concat "/#{file}"
                fs.unlinkSync fileAbsolutePath
