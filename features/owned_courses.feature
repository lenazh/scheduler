Feature: Courses I own

  As a User,
  So that I can manage my courses
  I want to have a list of courses that I can edit


Background:
  Given the web site is set up
  Given "user" is logged in
  And I am on the courses page


Scenario: Adding a class with a valid name
  When I fill in "name" with "Catology"
  And I press "Add"
  Then I should see "Catology" in owned classes


Scenario: Adding a class with invalid name
  When I fill in "name" with ""
  Then "Add" button should be disabled


Scenario: Renaming a class
  Given "Kerbology" class exists
  And I edit this class
  When I fill in "name" with "Spaceflight 101"
  And I press "Update"
  Then I should see "Spaceflight 101" in owned classes


Scenario: Cancelling a class renaming
  Given "Kerbology" class exists
  And I edit this class
  When I fill in "name" with "Spaceflight 101"
  And I press "Cancel"
  Then I shouldn't see "Spaceflight 101" in owned classes
  And I should see "Kerbology" in owned classes


Scenario: Renaming a class with invalid name
  Given "Kerbology" class exists
  And I edit this class
  When I fill in "name" with ""
  Then "Update" button should be disabled


Scenario: Deleting a class
  Given "Kerbology" class exists
  And I delete this class
  Then I shouldn't see "Kerbology" in owned classes


Scenario: Renaming a class that is on navbar
  Given "Kerbology" class exists
  And I select this class
  And I should see "Kerbology" in navigation bar title
  And I am on the courses page
  When I edit this class
  And I fill in "name" with "Spaceflight 101"
  And I press "Update"
  Then I should see "Spaceflight 101" in navigation bar title


Scenario: Deleting a class that is on navbar
  Given "Kerbology" class exists
  And I select this class
  And I should see "Kerbology" in navigation bar title
  And I am on the courses page
  When I delete this class
  Then I shouldn't see "Spaceflight 101" in navigation bar title


Scenario: Manage GSIs button
  Given "Kerbology" class exists
  When I press "Manage GSIs"
  Then I should see "GSI employment" section


Scenario: Select a class
  Given "Kerbin geopolitics" class exists
  When I select this class from the classes I own
  Then I should see "Schedule" section