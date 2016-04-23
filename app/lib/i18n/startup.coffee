setDefaultLanguage = ->
    ### Sets the default language for the system.###
    i18n.setDefaultLanguage 'en'


exports.setDefaultLanguage = setDefaultLanguage


Meteor.startup setDefaultLanguage
