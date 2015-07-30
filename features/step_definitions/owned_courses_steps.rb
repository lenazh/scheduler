def owned_class_id(name)
  within('#owned-classes') do
    return find_button(name)['id'].match(/owned-class-(\d+)/)[1]
  end
end

Then(/^I should(n't)? see "(.*?)" in owned classes$/) do |negate, name|
  within('#owned-classes') do
    if negate
      expect(page).to have_no_content name
    else
      expect(page).to have_content name
    end
  end
end

Then(/^"(.*?)" button should be disabled$/) do |name|
  expect(page).to have_button(name, disabled: true)
end

When(/^I edit this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-edit").click
end

When(/^I delete this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-delete").click
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end