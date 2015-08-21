Given(/^"(.*?)" class exists$/) do |name|
  create_class name
end

When(/^I select this class$/) do
  click_link 'My Classes'
  click_button @class, match: :first
end

When(/^I select this class from the classes I teach$/) do
  click_link 'My Classes'
  within('#teaching-classes') do
    click_button @class
  end
end

When(/^I select this class from the classes I own$/) do
  click_link 'My Classes'
  within('#owned-classes') do
    click_button @class
  end
end

Given(/^"(.*?)" class is selected$/) do |name|
  click_link 'My Classes'
  click_button name, match: :first
end

Then(/^I should(n't)? see "(.*?)" in owned classes$/) do |negate, name|
  expect_content_within '#owned-classes', name, negate
end

When(/^I edit this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-edit").click
end

When(/^I delete this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-delete").click
end
