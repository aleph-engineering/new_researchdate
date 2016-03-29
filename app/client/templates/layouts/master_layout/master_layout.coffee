@isBusy = new ReactiveVar false

Template.MasterLayout.helpers {
  isBusy: ->
    isBusy.get()
}

Template.MasterLayout.events {}
