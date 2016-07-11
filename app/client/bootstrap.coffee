Meteor.startup ->
    Session.setDefault 'process', true

    Meteor.Dropzone.options = {
        url: '#',
        autoProcessQueue: false,
        addRemoveLinks: true,
        uploadMultiple: false,
        parallelUploads: 1,
        maxFiles: 1,
        maxFilesize: 520
    }

