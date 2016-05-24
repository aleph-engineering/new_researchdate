class HomeController extends RouteController

    constructor: ->
        super


    waitOn: ->
        Meteor.subscribe 'latestTimestamps'


    action: ->
        do @render


exports.HomeController = @HomeController = HomeController
