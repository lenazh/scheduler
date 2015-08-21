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
