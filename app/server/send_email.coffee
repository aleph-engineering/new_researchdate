Meteor.settings.contactForm =
    emailTo: 'helencaridadgarcia810@gmail.com'
    emailSubject: (params) ->
        'Message from ' + params.name + ' via contact form'

Meteor.startup ->
    process.env.MAIL_URL="smtp://helencaridadgarcia810@gmail.com:helen.garcia@smtp.gmail.com:587/"
#    process.env.MAIL_URL = "smtp://contact+heroku@aleph.engineering:Owulacja7!@smtp.sendgrid.net:587"
