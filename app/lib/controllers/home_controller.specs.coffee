###
# This module aims to test the implementation of the HomeController class.
###

homeController = require './home_controller'
HomeController = homeController.HomeController


describe 'HomeController', ->
    beforeEach ->
        @meteorSubscribeMethod = sinon.spy Meteor, 'subscribe' if Meteor.isClient
        @homeController = new HomeController()
        @contextMock =
            next: ->

        @checkHomeControllerMethodCallsNextMethod = (method) ->
            nextMethod = sinon.spy @contextMock, 'next'
            method.apply @contextMock
            assert nextMethod.calledOnce

    afterEach ->
        do @meteorSubscribeMethod.restore if Meteor.isClient

    it 'should be defined', ->
        expect(HomeController).to.not.be.undefined

    # This should only run in the client, not available below Meteor functions in the server
    if Meteor.isClient
        it 'waits on latestTimestamps query to finish subscription', ->
            do @homeController.waitOn
            assert @meteorSubscribeMethod.calledOnce
            assert @meteorSubscribeMethod.calledWith 'latestTimestamps'

        it 'onRun calls next function in request handling pipeline', ->
            @checkHomeControllerMethodCallsNextMethod @homeController.onRun

        it 'onRerun calls next function in request handling pipeline', ->
            @checkHomeControllerMethodCallsNextMethod @homeController.onRerun
