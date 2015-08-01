def create_gsi_do(email, hours)
  fill_in 'email', with: email
  fill_in 'hours', with: hours
  click_button 'Add'
  expect(page).to have_content email
end

def create_gsi(email, hours)
  @gsi = {}
  @gsi[:email] = email
  @gsi[:hours] = hours 
  click_link 'GSIs'
  within('#gsi-roster') do
    if page.has_content? email
      return
    else
      create_gsi_do(email, hours)
    end
  end
end

def employment_id(gsi)
  email = gsi[:email]
  within('#gsi-roster') do
    return find('td', text: email)['id'].match(/gsi-email-(\d+)/)[1]
  end
end


Given(/^"(.*?)" class exists and selected$/) do |name|
  create_class name
  @class = name
  click_button @class
end

Then(/^I should(n't)? see "(.*?)" in GSI list$/) do |negate, value|
  within('#gsi-roster') do
    if negate
      expect(page).to have_no_content value
    else
      expect(page).to have_content value
    end
  end
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
