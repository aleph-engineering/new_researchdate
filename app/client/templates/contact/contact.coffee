Template.Contact.events {
}

Template.Contact.helpers {
}

Template.Contact.onCreated ->

Template.Contact.onRendered ->
    $('#contact-page-link').addClass 'active'

Template.Contact.onDestroyed ->
    $('#contact-page-link').removeClass 'active'



