hooks = ->

  @Before ->
    @generalUpload = (id, filename) =>
      browser.chooseFile id, './tests/media/'.concat filename

module.exports = hooks


