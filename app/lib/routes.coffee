Router.configure
  layoutTemplate: 'MasterLayout'
  loadingTemplate: 'Loading'
  notFoundTemplate: 'NotFound'


Router.route '/',
  name: 'home'
  controller: 'HomeController'
  where: 'client'

Router.route '/timestamp',
  name: 'timestamp'
  controller: 'TimestampController'
  where: 'server'