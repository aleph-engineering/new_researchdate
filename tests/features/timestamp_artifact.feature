Feature: Timestamp an artifact

  As a visitor to the site,
  so that I can have proof of the existence of an artifact at a specific time,
  I want to generate a timestamp.


  Background:
    Given I am on the homepage


  Scenario: Timestamp an artifact
    Given I provide the digital artifact "TEST.txt"
    When I submit the form
    Then the site returns to me a timestamp
    And returns the encrypted hash
