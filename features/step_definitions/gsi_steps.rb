Given(/^"(.*?)" class exists and selected$/) do |name|
  create_class name
  @class = name
  click_button @class
end

Then(/^I should(n't)? see "(.*?)" in GSI list$/) do |negate, value|
  expect_content_within '#gsi-roster', value, negate
end

Given(/^a GSI with "(.*?)" email working "(.*?)" hours a week exists$/) do |email, hours|
  create_gsi(email, hours)
end

Given(/^I edit this GSI$/) do
  id = employment_id(@gsi)
  find_button("gsi-#{id}-edit").click
end

Given(/^I delete this GSI$/) do
  id = employment_id(@gsi)
  find_button("gsi-#{id}-delete").click
end
