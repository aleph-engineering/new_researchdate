exports.Timestamps = @Timestamps = new Mongo.Collection 'timestamps'

TimestampIndex = new EasySearch.Index({
    collection: Timestamps,
    fields: ['hash', 'server'],
    engine: new EasySearch.MongoDB({
        sort: -> { creationDate: -1 },
    }),
})

TimestampSchema = new SimpleSchema({
    hash: {
        type: String
    },
    creationDate: {
        type: Date
    },
    server: {
        type: String
    }
})

Timestamps.attachSchema(TimestampSchema)

exports.TimestampIndex = TimestampIndex
