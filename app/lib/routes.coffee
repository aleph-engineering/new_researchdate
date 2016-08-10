configure = ->
    Router.configure
        layoutTemplate: 'MasterLayout'
        loadingTemplate: 'Loading'
        notFoundTemplate: 'NotFound'

    # This is the home route, the one leading to the home page
    Router.route '/',
        name: 'Home'
        controller: 'HomeController'
        where: 'client'

    # This one leads is to the timestamping action
    Router.route '/timestamp',
        name: 'Timestamp'
        controller: 'TimestampController'

    #  This is the Contact an About us route.
    Router.route '/contact',
        name: 'Contact'
        controller: 'ContactController'


do configure


exports.configure = configure
