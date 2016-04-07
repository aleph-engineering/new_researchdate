digest = require '../../lib/digest_generator'
verifier = require '../../../lib/timestamp_verification'

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $(e.target).find('#tsr-hash-input').get(0).files
        origin = $(e.target).find('#original-file-input').get(0).files
        digest.generateDigest origin[0], (error, result)->
            if error
                console.log error
            else
                if tsr.length > 0
                    file = tsr[0]
                    reader = new FileReader()
                    reader.onload = (evt) ->
                        if evt.target.error == null
                            responseBuffer = new Buffer evt.target.result
                            verifier.verifyTimestamp(result, responseBuffer)

                    reader.readAsArrayBuffer file
}


Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->


