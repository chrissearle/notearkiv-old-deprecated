Feature: Composer
  In order to categorize by composer
  As an archivist
  I want to be able to manage composers


  Scenario Outline: Composers List
    Given the following role records
      | name   |
      | admin  |
      | normal |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
      | normal   | secret   | normal |
    And I have composers called Mozart, Bach, Strauss
    And I am logged in as "<login>" with password "secret"
    When I go to the list of composers
    Then I should <action1>
    And I should <action2>
    And I should <action3>

  Examples:
    | login  | action1          | action2                                         | action3           |
    | admin  | see "Mozart"     | see "Bach"                                      | see "Strauss"     |
    | normal | see "Mozart"     | see "Bach"                                      | see "Strauss"     |
    | guest  | be on login_path | see "Beklager - du har ikke tilgang til dette." | not see "Strauss" |