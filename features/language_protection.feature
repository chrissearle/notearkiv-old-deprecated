Feature: Language Protection
  In order to categorize by language
  As a non-archivist
  I want to be able to see languages

  Background:
    Given the following role records
      | name   |
      | normal |
    And the following user records
      | username | password | role   |
      | normal   | secret   | normal |

  Scenario Outline: Languages List
    Given I have languages called Fransk, Latin, Svensk
    And I am logged in as "<login>" with password "secret"
    When I go to the list of languages
    Then I should <action1>
    And I should <action2>
    And I should <action3>
    And I should not see "endre"
    And I should not see "slett"

  Examples:
    | login  | action1              | action2                                         | action3          |
    | normal | see "Fransk"         | see "Latin"                                     | see "Svensk"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Svensk" |


  Scenario: Add language as normal
    Given I have no languages
    And I am logged in as "normal" with password "secret"
    When I visit the new language page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Add language as guest
    Given I have no languages
    When I visit the new language page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Edit language form as normal
    Given I have language called Fransk
    And I am logged in as "normal" with password "secret"
    When I visit the edit language page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

  Scenario: Edit language form as guest
    Given I have language called Fransk
    When I visit the edit language page
    Then I should be on the login page
    And I should see "Beklager - du har ikke tilgang til dette."

