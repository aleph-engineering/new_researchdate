@isBusy = new ReactiveVar false


Template.MasterLayout.helpers {
    isBusy: ->
        isBusy.get()
}


Template.MasterLayout.onRendered ->
    do $(".button-collapse").sideNav;
