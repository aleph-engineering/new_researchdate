#defaultMsg = i18n('loading.message')
#Session.setDefault 'waitMessage', defaultMsg
#spinner = Blaze.toHTML(Template.Spinner)
#
#
#Template.Loading.rendered = () ->
#  msgText = Session.get 'waitMessage'
#  message = "<p class='loading-message'>#{msgText}</p>"
#
#  @loading = window.pleaseWait({
#    logo: '',
#    backgroundColor: '#29b6f6',
#    loadingHtml: message + spinner
#  })
#
#Template.Loading.destroyed = () ->
#  Session.set 'waitMessage', defaultMsg
#  if @loading
#    @loading.finish()
