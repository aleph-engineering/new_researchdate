
Template.MasterLayout.helpers {
}

Template.MasterLayout.events {
    'click #googlebtn': (e) ->
        Meteor.loginWithGoogle {
            requestOfflineToken: true,
            forceApprovalPrompt: true,
            requestPermissions: ['https://www.googleapis.com/auth/drive.file']
        }

    'click #facebookbtn': (e) ->
        console.log 'pepe'

        Meteor.loginWithFacebook {
            requestPermissions: ['email', 'public_profile', 'user_friends', 'user_likes']
        }
}

Template.MasterLayout.onRendered ->
    do $(".button-collapse").sideNav
