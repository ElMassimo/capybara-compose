@selenium_chrome_headless
Feature: Cities
  Background:
    Given there is an "NYC" city
    And I visit the cities page
    And there should be an "NYC" city

  Scenario: Creating a city
    When I add a city:
    | name | Minneapolis |
    And I go back to the cities
    Then there should be a "Minneapolis" city

  Scenario: Attempting to create a city without a name
    When I add a city:
    | name | |
    Then I should see a "Name can't be blank" error in the form

  Scenario: Editing a city
    When I edit the "NYC" city with:
    | name | New York City |
    Then there should be a "New York City" city
    And there should not be an "NYC" city

  @phone
  Scenario: Deleting a city
    When I delete the "NYC" city
    Then there should not be an "NYC" city
