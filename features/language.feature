Feature: Language
  In order to categorize by language
  As an archivist
  I want to be able to manage languages

  Background:
    Given the following role records
      | name   |
      | admin  |
      | normal |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
      | normal   | secret   | normal |

  Scenario Outline: Languages List
    Given I have languages called Fransk, Latin, Svensk
    And I am logged in as "<login>" with password "secret"
    When I go to the list of languages
    Then I should <action1>
    And I should <action2>
    And I should <action3>

  Examples:
    | login  | action1              | action2                                         | action3          |
    | admin  | see "Fransk"         | see "Latin"                                     | see "Svensk"     |
    | normal | see "Fransk"         | see "Latin"                                     | see "Svensk"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Svensk" |


  Scenario Outline: Languages List Edit Link
    Given I have languages called Fransk
    And I am logged in as "<login>" with password "secret"
    When I go to the list of languages
    Then I should <action1>
    And I should <action2>

  Examples:
    | login  | action1              | action2                                         |
    | admin  | see "Fransk"         | see "endre"                                     |
    | normal | see "Fransk"         | not see "endre"                                 |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." |