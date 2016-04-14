Meteor.startup ->
    Meteor.Dropzone.options = {
        url: '#',
        addRemoveLinks: true,
        uploadMultiple: false,
        maxFiles: 1
    }
