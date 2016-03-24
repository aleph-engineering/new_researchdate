module.exports = ->
  'use strict'

  fs = require 'fs'

  # Build the absolute path the Downloads folder of the current user profile, where is supposed to be downloaded the
  # generated file. NOTE: that is the browser used for the tests must have this route as the default downloads folder,
  # otherwise the test won't work.
  downloadsFolder = (process.env.HOME || process.env.USERPROFILE).concat '/Downloads'


  countFilesInFolder = (folder) ->
    ### Counts the files in the given folder path. ###
    fs.readdirSync(folder).length

  countFilesInDownloadsFolder = ->
    ### Counts the files in the current user profile's Downloads folder path. ###
    countFilesInFolder downloadsFolder

  # For now the single expectation we have is that another .tsr file is being downloaded to the Downloads folder as
  # result of the timestamping
  formerTsrFilesInDownloadsFolder = do countFilesInDownloadsFolder

  @Given /^I provide the digital artifact "([^"]*)"$/, (filename) ->
    browser.chooseFile 'input[type="file"]', './tests/media/'.concat filename

  @When /^I submit the form$/, ->
    browser.submitForm '#artifact-form'

  @Then /^the site returns to me a timestamp$/, ->
    actualTsrFilesCount = do countFilesInDownloadsFolder
    expect(actualTsrFilesCount).toBe formerTsrFilesInDownloadsFolder + 1

  @Then /^returns the encrypted hash$/, ->
    hashValue = browser.getValue '#hash'
    expect(hashValue).toMatch /^[a-f0-9]{64}$/
