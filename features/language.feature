Feature: Language
  In order to categorize by language
  As an archivist
  I want to be able to manage languages

  Background:
    Given the following role records
      | name   |
      | admin  |
    And the following user records
      | username | password | role   |
      | admin    | secret   | admin  |
    And I am logged in as "admin" with password "secret"

  Scenario: Languages List
    Given I have languages called Fransk, Latin, Svensk
    When I go to the list of languages
    Then I should see "Fransk"
    And I should see "Latin"
    And I should see "Svensk"
    And I should see "endre"
    And I should see "slett"

  Scenario: Add language as admin
    Given I have no languages
    When I add the language Norsk
    Then I have 1 language
    And the language name is Norsk

  Scenario: Edit language form as admin
    Given I have language called Fransk
    When I visit the edit language page
    Then the "Språk" field should contain "Fransk"

  Scenario: Edit language as admin
    Given I have language called Fransk
    When I edit the language name to Svensk
    Then I have 1 language
    And the language name is Svensk
    And I should see "Svensk"
    And I should not see "Fransk"

  Scenario: Delete language as admin
    Given I have language called "Tysk"
    And I am on the languages page
    When I follow "slett"
    Then I have 0 languages
    And I should see /Språk "Tysk" slettet/
