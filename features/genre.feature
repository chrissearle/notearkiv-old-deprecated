Feature: Genre
  In order to categorize by genre
  As an archivist
  I want to be able to manage genres

  Background:
    Given the following role records
      | name   |
      | admin  |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
    And I am logged in as "admin" with password "secret"

  Scenario: Genre List
    Given I have genres called Folketone, Koral, Nasjonalsang
    When I go to the list of genres
    Then I should see "Folketone"
    And I should see "Koral"
    And I should see "Nasjonalsang"
    And I should see "endre"
    And I should see "slett"

  Scenario: Add genre as admin
    Given I have no genres
    When I add the genre Folketone
    Then I have 1 genre
    And the genre name is Folketone

  Scenario: Edit genre form as admin
    Given I have genre called Koral
    When I visit the edit genre page
    Then the "Genre" field should contain "Koral"

  Scenario: Edit genre as admin
    Given I have genre called Koral
    When I edit the genre name to Nasjonalsang
    Then I have 1 genre
    And the genre name is Nasjonalsang
    And I should see "Nasjonalsang"
    And I should not see "Koral"

  Scenario: Delete genre as admin
    Given I have genre called "Hymne"
    And I am on the genres page
    When I follow "slett"
    Then I have 0 genres
    And I should see /Genre "Hymne" slettet/
