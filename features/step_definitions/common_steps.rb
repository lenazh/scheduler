Then(/^"(.*?)" button should be disabled$/) do |name|
  expect(page).to have_button(name, disabled: true)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When(/^I click "(.*?)"$/) do |link|
  click_link link
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end
