@TimestampController = RouteController.extend(
# A place to put your subscriptions
# this.subscribe('items');
# # add the subscription to the waitlist
# this.subscribe('item', this.params._id).wait();

  subscriptions: ->

# Subscriptions or other things we want to "wait" on. This also
# automatically uses the loading hook. That's the only difference between
# this option and the subscriptions option above.
# return Meteor.subscribe('post', this.params._id);

  waitOn: ->

# A data function that can be used to automatically set the data context for
# our layout. This function can also be used by hooks and plugins. For
# example, the "dataNotFound" plugin calls this function to see if it
# returns a null value, and if so, renders the not found template.
# return Posts.findOne({_id: this.params._id});

  data: ->

# You can provide any of the hook options

  onRun: ->
    @next()
  onRerun: ->
    @next()
  onBeforeAction: ->
    if @request.method == 'POST'
      @next()
    else
      @response.statusCode = 403
      @response.end 'Not allowed'

# The same thing as providing a function as the second parameter. You can
# also provide a string action name here which will be looked up on a Controller
# when the route runs. More on Controllers later. Note, the action function
# is optional. By default a route will render its template, layout and
# regions automatically.
# Example:
#  action: 'myActionFunction'

  action: ->
    hash = @request.body.hash
    resp = @response
    Meteor.call 'server/timestamp', hash, (error, result) ->
      if error
        console.log "Error!!"
      else
        resultBuffer = new Buffer(result)
        filename = 'encrypted_hash.tsr'
        headers =
          'Content-Type': 'application/timestamp-reply',
          'Content-Disposition': "attachment; filename=" + filename
        resp.writeHead 200, headers
        return resp.end resultBuffer

  onAfterAction: ->
  onStop: ->

)
