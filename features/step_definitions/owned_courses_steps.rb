def owned_class_id(name)
  within('#owned-classes') do
    return find_button(name)['id'].match(/owned-class-(\d+)/)[1]
  end
end

def create_class(name)
  @class = name
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

Given(/^"(.*?)" class exists$/) do |name|
  create_class name
end

When(/^I select this class$/) do
  click_link 'My Classes'
  click_button @class
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

When(/^I edit this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-edit").click
end

When(/^I delete this class$/) do
  id = owned_class_id(@class)
  find_button("owned-class-#{id}-delete").click
end
