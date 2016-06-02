Feature: Timestamp an artifact

    As a visitor to the site,
    so that I can have proof of the existence of an artifact at a specific time,
    I want to generate a timestamp.


    Background:
        Given I am on the timestamp page

    Scenario: Generate timestamp an artifact
        And I provide a valid digital artifact
        When I submit the form
        Then the site returns to me a zip file containing the timestamp

    Scenario: Generate timestamp with an artifact bigger than 256 MB
        When I provide a digital artifact bigger than 256 MB
        Then I can see the require areas focused
        And  I can see a message saying remove the file

#    Scenario: Generate timestamp with empty form
#        When I submit the timestamp empty form
#        Then I can see the require areas focused
