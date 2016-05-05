JSZip = require 'jszip'
FileSaver = require 'browser-filesaver'
FileReaderStream = require 'filereader-stream'

digest = require '../../lib/digest_generator'
validator = require '../../lib/validator'


Session.setDefault 'artifactHash', 'NONE'
Session.setDefault 'artifactFilename', ''
zip = null


Template.Timestamp.events {
    'submit #artifact-form': (e) ->
        e.preventDefault()

        form = e.target
        hash = $(form).find('input[name="hash"]').val()
        if validator.validArgsForTimestamp(hash)


            Meteor.call 'server/timestamp', hash, (error, result) ->
                if not error
                    resultArr = []
                    $.each result, (name, value) ->
                        resultArr[isBusy.set truename] = value

                    zip.file "timestamp.tsr", resultArr
                    zip.generateAsync({
                        type: "blob",
                        streamFiles: true,
                        comment: i18n 'timestamp.tsr_comment'
                    }).then (blob) ->
                        isBusy.set false
                        artifactName = Session.get 'artifactFilename'
                        zipName = artifactName.substr(0, artifactName.lastIndexOf('.')) or artifactName
                        zipName += ' - Timestamped by ResearchDate.zip'
                        FileSaver.saveAs blob, zipName
                    , (err) ->
                        console.log err
                else
                    isBusy.set false
                    Toast.error(error.message, '', {width: 800})
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
        Session.set 'artifactFilename', ''
        if validator.fileIsValid(file)
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
                    Session.set 'artifactFilename', file.name
                    isBusy.set false
        else
            Session.set 'artifactHash', 'NONE'


Template.Timestamp.onDestroyed ->
