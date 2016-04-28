Feature: Timestamp an artifact

  As a visitor to the site,
  so that I can have proof of the existence of an artifact at a specific time,
  I want to generate a timestamp.


  Background:
    Given I am on the homepage

  Scenario: Generate timestamp an artifact
    And I provide a digital artifact
    When I submit the form
    Then the site returns to me a timestamp
    And returns the encrypted hash


  Scenario: Error generating timestamp for an artifact
    When I submit the form
#    Then the site return error
#    And no returns the encrypted hash
