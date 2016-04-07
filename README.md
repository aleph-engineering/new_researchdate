# Researchdate
Research Date is an available solution for protecting the integrity of
digital data, but also it will provide a mechanism to proof that such
data existed at a certain time.


#### How to use it

In order to start using the project there are some requirements to be
fulfilled.

1.  You need to install Node.JS in your computer. Version 5.* should be
    OK. In the following site you can find details of how to install it:
    https://nodejs.org/. You must ensure that with Node.JS, also the NPM
    tool is installed. In OS like Windows this is the default behavior
    when installing Node.JS.

2.  You need to install the iron-meteor package for Node.JS. In your
    command-line type: <code>npm install -g iron-meteor</code> (you may
    probably require administrative permissions to do this, if this is
    the case, then provide them). Iron-meteor is a management tool for
    Meteor's projects, allowing you to easily prepare their structure,
    control their execution and many other things.

3.  You need the Meteor web framework, which relays in Node.JS to work. The
    following site will also tell how to install it:
    https://www.meteor.com/.

Both technologies are available for Windows, Linux and Mac,
so feel comfortable to install them wherever you desire.



#### Getting the project

The fastest way to have it is by cloning this repository:
https://github.com/aleph-engineering/new_researchdate. So, going to the
directory you want to host the project folder and typing in your
command-line the following: <code>git clone \<mentioned-url\> \<project-name\></code>
will make you have the project already in your computer and ready to be
executed. Note: You can use any git utility you want to do this,
such as: <strong>SourceTree</strong> or <strong>TortoiseGit</strong>.


#### Then, how to execute it?

This is the easiest part ever, just:

1.  Go inside the project (assuming you have following the previous
    steps), just type: <code>cd \<project-name\></code>.
    
2.  And then type: <code>iron run</code>, and it should start
    executing on http://localhost:3000 by default.

Note: There cannot be another service running on that port or the
project won't run and complain about it. If this would be the case, then
stop the actual running service, or specify another port for Meteor to
run using the following: <code>iron run -p \<port\></code>.
