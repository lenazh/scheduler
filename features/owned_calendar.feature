Feature: Calendar of the class that belongs to me

  As a User,
  I want to be able to create sections so that the autoscheduler can schedule them for me

Background:
  Given the web site is set up
  Given "user" is logged in
  Given "Kerbology" class exists and selected
  And I click "Schedule"

Scenario: Section has a "collapse" button
  Given I create "Spaceflight" at "12:00" on "Monday"
  And I expand "Spaceflight" section
  Then I should see the minimize button
  And when I click the minimize button the section collapses