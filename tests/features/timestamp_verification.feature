Feature: Timestamp verification

    As a visitor to the site,
    so that I can have proof of the existence of an artifact at a specific time,
    I want to verify a timestamp.


    Background:
        Given I am on the verify tab

    Scenario: Successful verification
        And I provide a valid zip file
        When I submit the verify form
        Then I can see a message saying that the verification was successful

    Scenario: Unsuccessful verification
        And I provide a invalid zip file
        When I submit the verify form
        Then I can see a message saying that the verification was unsuccessful

    Scenario: Error in verification when .zip file not contain .tsr file
        And I provide a zip file that does not contain .tsr file
        When I submit the verify form
        Then I can see a message saying that zip does not contain a timestamp file

    Scenario: Error in verification when .zip file only contain a .tsr file
        And I provide a zip file that does not contain a timestamped file
        When I submit the verify form
        Then I can see a message saying that does not contain a timestamped file
