Meteor.startup ->
    Meteor.Dropzone.options = {
        addRemoveLinks: true,
        uploadMultiple: false,
        maxFiles: 1
    }
