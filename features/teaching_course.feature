Feature: Courses I teach

  As a User,
  So that I can see which classes I teach and 
  navigate between them
  I want to have a list of courses that I teach

Background:
  Given the web site is set up
  Given "user" is logged in
  Given "Kerbology" class exists
  And I select this class
  And "user" is teaching for this class
  And I select this class from the classes I teach
  And I am on the courses page

Scenario: View GSIs button
  When I press "View GSIs"
  Then I should see "GSI employment" section


Scenario: Select a class
  When I select this class from the classes I teach
  Then I should see "Schedule" section