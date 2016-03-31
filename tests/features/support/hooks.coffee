module.exports = ->
    clearServer = ->
        server.execute ->
# TODO: Uncomment: Timestamps.remove {}

    @Before ->
        @generalUpload = (id, filename) =>
            browser.chooseFile id, './tests/media/'.concat filename

        do clearServer

        ### This will be executed each time the e2e tests are executed ###
        @userProfileFolder = process.env.HOME || process.env.USERPROFILE
        @downloadsFolder = @userProfileFolder.concat '/Downloads'


    @After ->
        ### This will be executed each time the e2e tests are executed ###
        fs = require 'fs'

        downloadsFolder = @downloadsFolder

        # Remove all the .tsr files
        fs.readdirSync(@downloadsFolder).forEach (file) ->
            if file.slice(file.length - 4) is '.tsr'
                fileAbsolutePath = downloadsFolder.concat "/#{file}"
                fs.unlinkSync fileAbsolutePath
