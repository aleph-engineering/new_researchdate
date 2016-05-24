Template.Home.events {}

Template.Home.helpers {}

# Home: Lifecycle Hooks
Template.Home.onCreated ->

Template.Home.onRendered ->
    $('ul.tabs').tabs();
    $('.indicator').remove();

Template.Home.onDestroyed ->
