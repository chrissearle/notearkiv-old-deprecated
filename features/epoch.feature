Feature: Epoch
  In order to categorize by epoch
  As an archivist
  I want to be able to manage epochs

  Background:
    Given the following role records
      | name   |
      | admin  |
      | normal |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
      | normal   | secret   | normal |

  Scenario Outline: Epoch List
    Given I have epochs called Renessanse, Nasjonalromantikk, Romantikken
    And I am logged in as "<login>" with password "secret"
    When I go to the list of epochs
    Then I should <action1>
    And I should <action2>
    And I should <action3>

  Examples:
    | login  | action1              | action2                                         | action3               |
    | admin  | see "Renessanse"     | see "Nasjonalromantikk"                         | see "Romantikken"     |
    | normal | see "Renessanse"     | see "Nasjonalromantikk"                         | see "Romantikken"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Romantikken" |


  Scenario Outline: Epoch List Edit Link
    Given I have epochs called Renessanse
    And I am logged in as "<login>" with password "secret"
    When I go to the list of epochs
    Then I should <action1>
    And I should <action2>

  Examples:
    | login  | action1              | action2                                         |
    | admin  | see "Renessanse"     | see "endre"                                     |
    | normal | see "Renessanse"     | not see "endre"                                 |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." |