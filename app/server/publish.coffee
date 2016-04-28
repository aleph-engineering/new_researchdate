SystemParameters = require 'lib/system_parameters'


makePublications = ->
    ###
        This function performs all the publications of the server, every single query there is need to access to from
        the client, is going to be published here.
    ###

# This published the latest timestamps generated in te system
    Meteor.publish(
        'latestTimestamps',
        -> Timestamps.find {}, {limit: SystemParameters.TIMESTAMP_LIST_COUNT, sort: {creationDate: -1}}
    )


# Do the actual publications process
do makePublications


# Make available this function from this module
exports.makePublications = makePublications
