index = require '../../../lib/collections/timestamps'

Template.TimestampList.helpers {

    timestampIndex: () =>
        index.TimestampIndex

    inputAttributes: ->
        {
        'name': 'search',
        'type': 'search'
        }
}

Template.TimestampList.onRendered ->

Template.TimestampList.onCreated ->

Template.TimestampList.events {
}
