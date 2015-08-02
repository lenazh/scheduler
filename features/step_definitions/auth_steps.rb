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
