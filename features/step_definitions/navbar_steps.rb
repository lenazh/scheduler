Then(/^I should see "(.*?)" items in menu$/) do |names|
  with_scope('navbar items') do
    names.split(/, /).each do |name|
      expect(page).to have_content(name)
    end
  end
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


Then(/^I should(n't)? see "(.*?)" in navigation bar title$/) do |negate, name|
  with_scope('navbar title') do
    if negate
      expect(page).to have_no_content(name)
    else
      expect(page).to have_content(name)
    end
  end
end

