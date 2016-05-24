configure = ->
    Router.configure
        layoutTemplate: 'MasterLayout'
        loadingTemplate: 'Loading'
        notFoundTemplate: 'NotFound'


    # This is the home route, the one leading to the home page
    Router.route '/',
        name: 'home'
        controller: 'HomeController'
        where: 'client'


    # This one leads is to the timestamping action
    Router.route '/timestamp',
        name: 'timestamp'
        controller: 'TimestampController'
        where: 'server'

do configure


exports.configure = configure
