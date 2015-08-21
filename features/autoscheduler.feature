Feature: Autoscheduler

  As a User,
  I want to schedule classes automatically so I don't have to spend time doing this manually

Background:
  Given the web site is set up
  Given "user" is logged in
  Given "Kerbology" class exists and selected
  And I click "Schedule"

#Scenario: Class with no sections
#  Then autoscheduler shouldn't be visible

#Scenario: Sections nobody can teach
#  Given I create "Spaceflight" at "12:00" on "Monday"
#  And I reload the page
#  Then I should see "Spaceflight" in sections nobody can teach

#Scenario: GSIs who can't make any class
#  Given "vasya" is teaching for this class
#  And I click "Schedule"
#  And I reload the page
#  Then I should see "vasya" in GSIs who can't teach enough classes to fulfill their appointment