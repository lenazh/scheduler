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
  expect_css_within 'body', selector, negate
end

Then(/^I should(n't)? see "(.*?)" in navigation bar title$/) do |negate, name|
  expect_content_within 'nav .navbar-brand', name, negate
end
