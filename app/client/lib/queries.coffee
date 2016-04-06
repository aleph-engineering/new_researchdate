exports.getLatestTimestamps = ->
    ###
        Returns the data of the latest timestamps generated in the system.
    ###
    Timestamps.find {}, {sort: {creationDate: -1}}
