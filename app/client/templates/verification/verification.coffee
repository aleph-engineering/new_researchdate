hashGenerate = @hashGenerate

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $(e.target).find('#tsr-hash-input').get(0).files
        origin = $(e.target).find('#original-file-input').get(0).files
#        #        for_now = $(e.target).find('#result-input')
#        #        for_now[0].value = 'Verification True'
        generateDigest origin[0], (error, result) ->
            if error
                console.log error
            else
                if tsr.length > 0
                    file = tsr[0]
                    reader = new FileReader()
                    reader.onload = (evt) ->
                        if evt.target.error == null
                            responseBuffer = new Buffer evt.target.result
                            response = parseTimestampResponse responseBuffer
                            console.log 'aaaa'
                            console.log getHashFromResponse response

                    reader.readAsArrayBuffer file



#          TODO (Helen Garcia Gonzalez): Write code here for call method 'server/verify'
#        Meteor.call 'server/verify', tsr[0], origin[0], (error, result) ->

}


Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

