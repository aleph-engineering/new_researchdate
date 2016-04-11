JSZip = require 'jszip'
FileSaver = require 'browser-filesaver'
FileReaderStream = require 'filereader-stream'

digest = require '../../lib/digest_generator'
validator = require '../../lib/validator'


Session.setDefault 'artifactHash', 'NONE'
zip = null


Template.Timestamp.events {
    'submit #artifact-form': (e) ->
        e.preventDefault()

        form = e.target
        hash = $(form).find('input[name="hash"]').val()
        if validator.validArgsForTimestamp(hash)
            isBusy.set true

            Meteor.call 'server/timestamp', hash, (error, result) ->
                if not error
                    resultArr = []
                    $.each result, (name, value) ->
                        resultArr[name] = value

                    zip.file "response.tsr", resultArr
                    zip.generateAsync({type: "blob"})
                    .then (blob) ->
                        isBusy.set false
                        FileSaver.saveAs blob, "test.zip"
                    , (err) ->
                        console.log err
        else
            $('#original-artifact').addClass('error')

}

Template.Timestamp.helpers {
    artifactHash: ->
        Session.get 'artifactHash'
}

# Timestamp: Lifecycle Hooks
Template.Timestamp.onCreated ->

Template.Timestamp.onRendered ->
    Dropzone.forElement('#original-artifact').on 'addedfile', (file)->
        Session.set 'artifactHash', ''
        if file?
            isBusy.set true

            fileStream = FileReaderStream file
            zip = new JSZip()
            zip.file file.name, fileStream

            digest.generateDigest file, (error, result) ->
                if error
#                    TODO (Marian Morgalo): Show a message to the user if an error occurs
                    console.log error
                else
                    Session.set 'artifactHash', result
                    isBusy.set false
        else
            Session.set 'artifactHash', 'NONE'


Template.Timestamp.onDestroyed ->
