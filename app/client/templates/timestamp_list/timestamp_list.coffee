Template.TimestampList.events {}


Template.TimestampList.helpers
    'latestTimestamps': -> Timestamps.find {}, {sort: {creationDate: -1}}


Template.TimestampList.onCreated ->


Template.TimestampList.onRendered ->


Template.TimestampList.onDestroyed ->
