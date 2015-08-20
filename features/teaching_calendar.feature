Feature: Calendar of the class that I teach

  As a User,
  I want to be able to input my section preferences so that the autoscheduler can pick the best section for me

Background:
  Given the web site is set up
  And "user" is logged in
  And "Kerbology" class exists and selected
  And "user" is teaching for this class
  And "Kerbology" class is selected
  And I click "Schedule"
  And I create "Spaceflight 101" at "14:00" on "Wednesday"
  And I switch to the preferences view

Scenario: Section has a "collapse" button
  Given I expand "Spaceflight 101" section
  Then I should see the minimize button
  And when I click the minimize button the section collapses