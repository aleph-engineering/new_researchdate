registerMethods = ->
    Meteor.methods
        'server/timestamp': (hash) ->
            do @unblock

            timestamping = require('./lib/timestamping')
            timestampGenerator = timestamping.getTimestampGenerator()
            timestampGenerator.timestamp hash


do registerMethods


exports.registerMethods = registerMethods
