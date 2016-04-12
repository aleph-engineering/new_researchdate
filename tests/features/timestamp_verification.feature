Feature: Timestamp verification

  As a visitor to the site,
  so that I can have proof of the existence of an artifact at a specific time,
  I want to verify a timestamp.


  Background:
    Given I am on the homepage

  Scenario: Successful verification
    Given I provide a encrypted hash "hash.tsr"
    And I provide the original artifact "TEST.txt"
    When I submit the verify form
    Then I can see a message saying that the verification was successful


  Scenario: Unsuccessful verification
    Given I provide an "invalid input"
    When I click the "Verify" button
    Then a message pops up saying that the verification was unsuccessfu
