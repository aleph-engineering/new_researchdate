Meteor.publish 'latestTimestamps', -> Timestamps.find {}, {limit: 4, sort: {creationDate: -1}}
