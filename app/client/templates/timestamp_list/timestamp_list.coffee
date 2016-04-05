Template.TimestampList.helpers
    'latestTimestamps': ->
        ###
            Returns the latest timestamps there were recently made in the system.
        ###
        Timestamps.find {}, {sort: {creationDate: -1}}
