timestamping = require './lib/timestamping'

registerMethods = ->
    Meteor.methods
        'server/timestamp': (hash, tsaUrl) ->
            do @unblock

            timestampGenerator = timestamping.getTimestampGenerator()
            timestampGenerator.timestamp hash, tsaUrl

do registerMethods


exports.registerMethods = registerMethods
