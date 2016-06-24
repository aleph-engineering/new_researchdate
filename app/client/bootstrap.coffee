Meteor.startup ->

    Meteor.Dropzone.options = {
        url: '#',
        autoProcessQueue: false,
        addRemoveLinks: true,
        uploadMultiple: false,
        parallelUploads: 1,
        maxFiles: 1,
        maxFilesize: 900
    }


    NProgress.configure({parent: "#timestamp-progress-bar", showSpinner: false, minimum: 0.3})

