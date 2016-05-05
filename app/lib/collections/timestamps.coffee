exports.Timestamps = @Timestamps = new Mongo.Collection 'timestamps'

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
