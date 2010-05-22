Feature: Composer
  In order to categorize by composer
  As an archivist
  I want to be able to manage composers

  Background:
    Given the following role records
      | name   |
      | admin  |
      | normal |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
      | normal   | secret   | normal |

  Scenario Outline: Composers List
    Given I have composers called Mozart, Bach, Strauss
    And I am logged in as "<login>" with password "secret"
    When I go to the list of composers
    Then I should <action1>
    And I should <action2>
    And I should <action3>

  Examples:
    | login  | action1              | action2                                         | action3           |
    | admin  | see "Mozart"         | see "Bach"                                      | see "Strauss"     |
    | normal | see "Mozart"         | see "Bach"                                      | see "Strauss"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Strauss" |

  Scenario Outline: Composers List Edit Link
    Given I have composers called Mozart
    And I am logged in as "<login>" with password "secret"
    When I go to the list of composers
    Then I should <action1>
    And I should <action2>

  Examples:
    | login  | action1              | action2                                         |
    | admin  | see "Mozart"         | see "endre"                                     |
    | normal | see "Mozart"         | not see "endre"                                 |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | 