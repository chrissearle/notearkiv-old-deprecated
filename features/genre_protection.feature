Feature: Genre Protection
  In order to categorize by genre
  As a non-archivist
  I want to be able to see genres

  Background:
    Given the following role records
      | name   |
      | normal |
    And the following user records
      | username | password | role   |
      | normal   | secret   | normal |

  Scenario Outline: Genre List
    Given I have genres called Folketone, Koral, Nasjonalsang
    And I am logged in as "<login>" with password "secret"
    When I go to the list of genres
    Then I should <action1>
    And I should <action2>
    And I should <action3>
    And I should not see "endre"
    And I should not see "slett"

  Examples:
    | login  | action1              | action2                                         | action3                |
    | normal | see "Folketone"      | see "Koral"                                     | see "Nasjonalsang"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Nasjonalsang" |

  Scenario: Add genre as normal
    Given I have no genres
    And I am logged in as "normal" with password "secret"
    When I visit the new genre page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Add genre as guest
    Given I have no genres
    When I visit the new genre page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Edit genre form as normal
    Given I have genre called Fransk
    And I am logged in as "normal" with password "secret"
    When I visit the edit genre page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Edit genre form as guest
    Given I have genre called Fransk
    When I visit the edit genre page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

    