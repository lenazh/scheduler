Feature: Navigation bar

  As a User,
  I want to be able to navigate between the pages of the app.
  So that I can access all the features

Background:
  Given the web site is set up
  Given "user" is logged in
  And I am on the root page


Scenario: All the menu items are present
  Then I should see "My Classes, GSIs, Schedule, Settings, Sign out" items in menu


Scenario: My classes navigates to the list of the classes I own and the classes I teach
  When I click "My Classes"
  Then I should see "I am head GSI of" section
  And I should see "Classes I teach" section


Scenario: Class name appears in navigation bar title when it's selected
  Given "Kerbology" class exists
  When I select this class
  Then I should see "Kerbology" in navigation bar title


Scenario: GSIs navigates to the GSI roaster section when a class is selected
  Given "Kerbology" class exists
  And I select this class
  When I click "GSIs"
  Then I should see "GSI roster" section


Scenario: Schedule navigates to the Schedule section when a class is selected
  Given "Kerbology" class exists
  And I select this class
  When I click "Schedule"
  Then I should see "Schedule" section


Scenario: Settings navigates to user account settings
  When I click "Settings"
  Then I should see "Settings" section


Scenario: Sign out signs out of the website
  When I click "Sign out"
  Then I should see "Sign in" section
