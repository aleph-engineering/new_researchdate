Feature: Display most recent timestamps
    As an anonymous user
    I want to see the most recent timestamps
    To see the recent site's activity.

    NOTE: That the list in the below steps will be referred as: recent timestamps list

    Scenario: Timestamped artifact generates items in the most recent timestamps
        Given exists some timestamps generated
        When I am on the homepage
        And I wait 2 seconds
        Then I can see 10 timestamps in the timestamps list
        And they are ordered in descendant by date

    Scenario: There is not timestamps in the most recent timestamps list
        Given not exist timestamps generated
        When I am on the homepage
        Then I can see there is not timestamps in the timestamps list
