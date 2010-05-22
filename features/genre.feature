Feature: Genre
  In order to categorize by genre
  As an archivist
  I want to be able to manage genres


  Scenario Outline: Genre List
    Given the following role records
      | name   |
      | admin  |
      | normal |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
      | normal   | secret   | normal |
    And I have genres called Folketone, Koral, Nasjonalsang
    And I am logged in as "<login>" with password "secret"
    When I go to the list of genres
    Then I should <action1>
    And I should <action2>
    And I should <action3>

  Examples:
    | login  | action1              | action2                                         | action3                |
    | admin  | see "Folketone"      | see "Koral"                                     | see "Nasjonalsang"     |
    | normal | see "Folketone"      | see "Koral"                                     | see "Nasjonalsang"     |
    | guest  | be on the login page | see "Beklager - du har ikke tilgang til dette." | not see "Nasjonalsang" |