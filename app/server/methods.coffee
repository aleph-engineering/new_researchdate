timestampGeneration = require('./lib/timestamping')


Meteor.methods
    'server/timestamp': (hash) ->
        do @unblock
        timestampGeneration.timestamp hash
