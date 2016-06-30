services = Meteor.settings.private.oAuth

if services

    for service in services
        ServiceConfiguration.configurations.upsert({service: service},
            {
                $set: services[service]
            });
