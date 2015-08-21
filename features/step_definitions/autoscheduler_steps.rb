Then(/^autoscheduler should(n't)? be visible$/) do |negate|
  expect_css_within 'body', '#autoscheduler-title', negate
end

Then(/^I should(n't)? see "(.*?)" in sections nobody can teach$/) do |negate, section|
  expect_content_within '#autoscheduler #sections-nobody-can-teach',
    section, negate
end

Then(/^I should(n't)? see "(.*?)" in GSIs who can't teach enough classes to fulfill their appointment$/) do |negate, name|
  expect_content_within '#autoscheduler #no-preference', name, negate
end
