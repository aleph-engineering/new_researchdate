Meteor.startup ->

    Meteor.Dropzone.options = {
        url: '#',
        addRemoveLinks: true,
        uploadMultiple: false,
        maxFiles: 1,
        dictCancelUpload: ''
    }


    NProgress.configure({parent: "#timestamp-progress-bar", showSpinner: false, minimum: 0.3})

