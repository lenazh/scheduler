# returns the calendar cell HTML ID attribute given hour and weekday
def calendar_cell_id(hour, weekday)
  weekday + hour.gsub(/:/, '')
end

Given(/^I create "(.*?)" at "(.*?)" on "(.*?)"$/) do |name, hour, weekday|
  find('td#' + calendar_cell_id(hour, weekday)).click
  fill_in 'name', with: name
  within('.event-expanded') do
    click_button 'Save'
  end
end

Given(/^I expand the section at "(.*?)" on "(.*?)"$/) do |hour, weekday|
  click_on "td##{calendar_cell_id(hour, weekday)} div.event"
end

Given(/^I expand "(.*?)" section$/) do |name|
  within('#schedule-table') do
    find('.section-name', text: name).click
  end
end

Then(/^I should see the minimize button$/) do
  within('.event-expanded') do
    expect(page).to have_css 'div.minimize-event'
  end
end

Then(/^when I click the minimize button the section collapses$/) do
  within('.event-expanded') do
    find('.minimize-event').click
  end
end

Given(/^"(.*?)" is teaching for this class$/) do |user|
  click_link 'GSIs'
  create_gsi email(user), 20
end

Given(/^I switch to the preferences view$/) do
  select('Preferences', from: 'schedule-role')
end
