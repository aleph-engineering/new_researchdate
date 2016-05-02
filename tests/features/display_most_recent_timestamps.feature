Feature: Display most recent timestamps
    As an anonymous user
    I want to see the most recent timestamps
    To see the recent site's activity.

    NOTE: That the list in the below steps will be referred as: recent timestamps list

    @dev
    Scenario: Timestamped artifact generates items in the most recent timestamps
        Given exist some timestamps generated
        When I am on the homepage
        Then I can see 4 timestamps in the timestamps list
        And they are ordered in descendant by date
