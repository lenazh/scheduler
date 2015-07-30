def email(user)
  "#{user}@example.com"
end

def password
  'password'
end

def sign_in(user)
  delete '/users/sign_out'
  visit '/users/sign_in'
  fill_in 'Email', with: email(user)
  fill_in 'Password', with: password
  click_button 'Sign in'
  return true if page.has_content? 'Signed in successfully'
  false
end

def current_user
  selector = '#user-name'
  return '' unless page.has_css? selector
  user = find selector
  user.text
end

def sign_up(user)
  delete '/users/sign_out'
  visit '/users/sign_up'
  fill_in 'Name', with: user
  fill_in 'Email', with: email(user)
  fill_in 'Password', with: password
  fill_in 'Password confirmation', with: password
  click_button 'Sign up'
end

def create_class(name)
  click_link 'My Classes'
  within('#owned-classes') do
    if page.has_content? name
      return
    else
      fill_in 'name', with: name
      click_button 'Add'
    end
  end
end

Given(/^the web site is set up$/) do
  # Place additional initialization here if needed
end

Given(/^"(.*?)" signed up$/) do |user|
  sign_up user
end

Given(/^"(.*?)" is logged in$/) do |user|
  if current_user != user
    unless sign_in user
      sign_up user
    end
  end
end

Then(/^I should see "(.*?)" items in menu$/) do |names|
  with_scope('navbar items') do
    names.split(/, /).each do |name|
      expect(page).to have_content(name)
    end
  end
end

When(/^I click "(.*?)"$/) do |link|
  click_link link
end

Then(/^I should(n't)? see "(.*?)" section$/) do |negate, name|
  id = name.downcase.gsub(/ /, '-')
  selector = "h1##{id}, h2##{id}, h3##{id}"
  if negate
      expect(page).to have_no_css selector
  else
    expect(page).to have_css selector
  end
end

Given(/^"(.*?)" class exists$/) do |name|
  create_class name
  @class = name
end

When(/^I select this class$/) do
  click_link 'My Classes'
  click_button @class
end

Then(/^I should(n't)? see "(.*?)" in navigation bar title$/) do |negate, name|
  with_scope('navbar title') do
    if negate
      expect(page).to have_no_content(name)
    else
      expect(page).to have_content(name)
    end
  end
end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end
