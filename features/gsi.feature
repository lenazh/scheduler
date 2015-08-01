Feature: GSI roaster

  As a User,
  I want to be able to enroll GSIs for my classes.
  So that the autoassignment system can figure their schedule for me.

Background:
  Given the web site is set up
  Given "user" is logged in
  Given "Kerbology" class exists and selected
  And I click "GSIs"


Scenario: Adding a GSI with valid data
  When I fill in "email" with "gsi@example.com"
  And I fill in "hours" with "20"
  And I press "Add"
  Then I should see "gsi@example.com" in GSI list
  And I should see "20" in GSI list


Scenario: Adding a GSI with invalid email
  When I fill in "email" with " "
  And I fill in "hours" with "20"
  Then "Add" button should be disabled


Scenario: Adding a GSI with invalid hours
  When I fill in "email" with "gsi@example.com"
  And I fill in "hours" with "blah"
  Then "Add" button should be disabled


Scenario: Changing GSI email
  Given a GSI with "gsi@example.com" email working "20" hours a week exists  
  And I edit this GSI
  When I fill in "email" with "kittens@berkeley.edu"
  And I press "Update"
  Then I should see "kittens@berkeley.edu" in GSI list
  And I should see "20" in GSI list


Scenario: Changing GSI hours
  Given a GSI with "gsi@example.com" email working "20" hours a week exists  
  And I edit this GSI
  When I fill in "hours" with "10"
  And I press "Update"
  Then I should see "gsi@example.com" in GSI list
  And I should see "10" in GSI list


Scenario: Cancelling a GSI editing
  Given a GSI with "gsi@example.com" email working "20" hours a week exists  
  And I edit this GSI
  When I fill in "email" with "crowbar@gmail.com"
  And I fill in "hours" with "66"
  And I press "Cancel"
  Then I shouldn't see "crowbar@gmail.com" in GSI list
  And I shouldn't see "66" in GSI list
  Then I should see "gsi@example.com" in GSI list
  And I should see "20" in GSI list


Scenario: Changing GSI email to invalid
  Given a GSI with "gsi@example.com" email working "20" hours a week exists  
  And I edit this GSI
  When I fill in "email" with "blah45"
  Then "Update" button should be disabled


Scenario: Changing GSI hours to invalid
  Given a GSI with "gsi@example.com" email working "20" hours a week exists  
  And I edit this GSI
  When I fill in "hours" with "blah45"
  Then "Update" button should be disabled


Scenario: Deleting a GSI
  Given a GSI with "gsi@example.com" email working "20" hours a week exists
  And I delete this GSI
  Then I shouldn't see "gsi@example.com" in GSI list

