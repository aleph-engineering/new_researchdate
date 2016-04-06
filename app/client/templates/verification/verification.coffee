hashGenerate = @hashGenerate

Template.Verification.events {
    'change input[name="tsr"]': (e) ->
        files = $(e.target).get(0).files
        if files.length > 0
            file = files[0]
            reader = new FileReader()
            reader.onload = (evt) ->
                console.log evt.target
                if evt.target.error == null
                    responseBuffer = new Buffer evt.target.result
                    console.log 'onload de reader'
                    response = parseTimestampResponse responseBuffer

            reader.readAsArrayBuffer file

    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $(e.target).find('#tsr-hash-input').get(0).files
        file = tsr[0]
        console.log file
        responseBuffer = new Buffer $(e.target).find('#tsr-hash-input').get(0).files.item
        console.log $(e.target).find('#tsr-hash-input').get(0).files.item
        response = parseTimestampResponse file
#        responseBuffer = new Buffer reader
#        console.log responseBuffer
#        reader.submit = (evt) ->
#            if evt.target.error == null
#            responseBuffer = new Buffer evt.target.result
#            console.log 'onload de reader2'
#            response = parseTimestampResponse responseBuffer
#        origin = $(e.target).find('#original-file-input').get(0).files
#        #        for_now = $(e.target).find('#result-input')
#        #        for_now[0].value = 'Verification True'
#        generateDigest origin[0], (error, result) ->
#            if error
#                console.log error
#            else


#          TODO (Helen Garcia Gonzalez): Write code here for call method 'server/verify'
#        Meteor.call 'server/verify', tsr[0], origin[0], (error, result) ->

}


Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

