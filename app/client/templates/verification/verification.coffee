hashGenerate = @hashGenerate

count = 0

my_async = () ->
    mf = -> count++
    setTimeout mf, 100

p = new Promise(my_async)

p.then (result) ->
    p2 = new Promise(my_async)
    p2.then (result2) ->
        console.log "result = #{result + result2}"

p.resolve()

generateDigestSync = Meteor.wrapAsync(generateDigest)

Template.Verification.events {

    'submit #verify-form': (e) ->
        e.preventDefault()
        tsr = $(e.target).find('#tsr-hash-input').get(0).files
        origin = $(e.target).find('#original-file-input').get(0).files
#        #        for_now = $(e.target).find('#result-input')
#        #        for_now[0].value = 'Verification True'
        #        res = generateDigestSync origin[0]
        #        console.log res


        v = generateDigestSync origin[0]
        console.log "pinga : #{v}"

        v = generateDigestSync origin[0]
        console.log "culo : #{v}"

        v = generateDigestSync origin[0]
        console.log "las piedras : #{v}"

#        , (error, result) ->
#            if error
#                console.log error
#            else
#                console.log result
##                if tsr.length > 0
#                    file = tsr[0]
#                    reader = new FileReader()
#                    reader.onload = (evt) ->
#                        if evt.target.error == null
#                            responseBuffer = new Buffer evt.target.result
#                            response = parseTimestampResponse responseBuffer
#                            a = getHashFromResponse response
#                            console.log a == result
#
#                    reader.readAsArrayBuffer file

}


Template.Verification.helpers {}

# Verification: Lifecycle Hooks
Template.Verification.onCreated ->

Template.Verification.onRendered ->

Template.Verification.onDestroyed ->

hashOfTsr = (tsr) ->
    if tsr.length > 0
        file = tsr[0]
        reader = new FileReader()
        reader.onload = (evt) ->
            if evt.target.error == null
                responseBuffer = new Buffer evt.target.result
                response = parseTimestampResponse responseBuffer
        #                console.log response
        #                a = getHashFromResponse response

        reader.readAsArrayBuffer file
