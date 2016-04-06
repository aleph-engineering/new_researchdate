queries = require '../../lib/queries'


Template.TimestampList.helpers
    'latestTimestamps': ->
        ###
            Returns the latest timestamps there were recently made in the system.
        ###
        do queries.getLatestTimestamps
