Feature: Display most recent timestamps
    As an anonymous user
    I want to see the most recent timestamps
    To see the recent site's activity.

    NOTE: That the list in the below steps will be referred as: recent timestamps list

    Background:
        Given I am on the homepage

    Scenario: Timestamped artifact generates items in the most recent timestamps
#        And I timestamp the artifacts:
#            | artifact  |
#            | TEST1.txt |
#            | TEST1.txt |
#            | TEST2.txt |
#            | TEST1.txt |
#            | TEST2.txt |
#            | TEST.txt  |
#        Then I should see until "4" timestamp records in the recent timestamps list
#        And The recent timestamps list is as expected: it shows the last "4" timestamps ordered in descendant order by creation date
