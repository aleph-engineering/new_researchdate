registerMethods = ->
    Meteor.methods
        'server/timestamp': (hash, tsaUrl) ->
            do @unblock

            timestamping = require('./lib/timestamping')
            timestampGenerator = timestamping.getTimestampGenerator()
            timestampGenerator.timestamp hash, tsaUrl


do registerMethods


exports.registerMethods = registerMethods
