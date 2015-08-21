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

Given(/^the web site is set up$/) do
  # Place additional initialization here if needed
end

Given(/^I reload the page$/) do
  visit current_path
end


When /^(?:|I )press "(.*?)"$/ do |button|
  click_button(button)
end
