module AuthHelpers
  # returns an email address given name
  def email(user)
    "#{user}@example.com"
  end

  # returns a password for a user
  def password
    'password'
  end

  # signs in the user given name
  def sign_in(user)
    delete '/users/sign_out'
    visit '/users/sign_in'
    fill_in 'Email', with: email(user)
    fill_in 'Password', with: password
    click_button 'Sign in'
    return true if page.has_content? 'Signed in successfully'
    false
  end

  # returns the current user name
  def current_user
    selector = '#user-name'
    return '' unless page.has_css? selector
    user = find selector
    user.text
  end

  # signs up a new user given name
  def sign_up(user)
    delete '/users/sign_out'
    visit '/users/sign_up'
    fill_in 'Name', with: user
    fill_in 'Email', with: email(user)
    fill_in 'Password', with: password
    fill_in 'Password confirmation', with: password
    click_button 'Sign up'
  end
end

World(AuthHelpers)
