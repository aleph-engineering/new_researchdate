describe 'Routes module', ->
    before ->
        @routerConfigure = sinon.stub Router, 'configure'
        @routerRoute = sinon.stub Router, 'route'
        @router = require './routes'
        do @router.configure

    after ->
        do @routerConfigure.restore
        do @routerRoute.restore


    it 'is defined', ->
        expect(@router).not.to.be.undefined


    it 'calls Router.configure method configuring template settings', ->
        assert(
            @routerConfigure.calledWith(
                layoutTemplate: 'MasterLayout'
                loadingTemplate: 'Loading'
                notFoundTemplate: 'NotFound'
            )
            'Router configure was not called correctly'
        )


    it 'sets up the home controller route', ->
        assert(
            @routerRoute.calledWithExactly '/', name: 'Home', controller: 'HomeController', where: 'client'
            'Was not configured the home controller route'
        )


    it 'sets up the timestamp controller route', ->
        assert(
            @routerRoute.calledWithExactly
            '/Timestamp',
            name: 'Timestamp',
            controller: 'TimestampController',
            'Was not configured the timestamp controller route'
        )
