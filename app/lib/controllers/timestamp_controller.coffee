class TimestampController extends RouteController

    constructor: ->
        super


    action: ->
        if @request.method is 'POST'
            hash = @request.body.hash
            resp = @response

            Meteor.call 'server/timestamp', hash, (error, result) ->
                if error
                    console.log "Occurred an error in the process!! Details below:"
                    console.log error
                else
                    arr = Object.keys(result).map (key) -> result[key]
                    resultBuffer = new Buffer arr

                    # Construct the http response for generated timestamping, in the form of a file
                    filename = 'hash.tsr'
                    headers =
                        'Content-Type': 'application/timestamp-reply',
                        'Content-Disposition': "attachment; filename=" + filename
                    resp.writeHead 200, headers

                    # Serve the file to the client
                    resp.end resultBuffer
        else
            do @render


exports.TimestampController = @TimestampController = TimestampController
