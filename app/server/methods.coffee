timestamping = require './lib/timestamping'

timestampGeneratorPromise = (hash, tsaUrl)->
    return new Promise(
        (resolve, reject) ->
            try
                timestampGenerator = timestamping.getTimestampGenerator()
                response = timestampGenerator.timestamp hash, tsaUrl
                resolve {response: response, tsa: tsaUrl}
            catch e
                reject e.toString()
    )

registerMethods = ->
    Meteor.methods
        'server/timestamp': (hash, tsaUrls) ->
            do @unblock
            promises = []
            tsaUrls.forEach (tsaUrl) ->
                promises.push timestampGeneratorPromise(hash, tsaUrl)

            Promise.all promises

do registerMethods


exports.registerMethods = registerMethods

