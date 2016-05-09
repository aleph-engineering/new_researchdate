Feature: Timestamp verification

    As a visitor to the site,
    so that I can have proof of the existence of an artifact at a specific time,
    I want to verify a timestamp.


    Background:
        Given I am on the homepage

    Scenario: Successful verification
        And I provide a valid zip file
#        And I provide the original file
        When I submit the verify form
        Then I can see a message saying that the verification was successful

    Scenario: Unsuccessful verification
        And I provide a invalid zip file
#        And I provide the original file
        When I submit the verify form
        Then I can see a message saying that the verification was unsuccessful

    Scenario: Verification with empty form
        When I submit the verify empty form
        Then I can see the require areas focused
        And no returns the encrypted hash
