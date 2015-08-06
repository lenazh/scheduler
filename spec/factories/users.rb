FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@gmail.com"
  end

  factory :user do
    name 'Darth Vader'
    email
    password 'password'
    password_confirmation 'password'

    factory :updated_valid_user, class: User do
      email 'vader@deathstar.mil'
    end
  end

  factory :invalid_user, class: User do
    name 'Twinky'
    email ' '
  end

  factory :another_user, class: User do
    name 'Sponge Bob Square Pants'
    email
  end

  factory :gsi, class: User do
    email

    after(:build) do |user|
      # name is assigned here because it's unpermitted parameter
      # for gsi controller
      user.name = 'Barney The Dinosaur'
      user.password = 'password'
      user.password_confirmation = 'password'
    end

    after(:create) do |user|
      course = create(:course)
      owner = create(:user)
      course.user = owner
      user.courses_to_teach << course
      section = create(:section, course: course)
      user.preferences << create(:preference, section: section, preference: 1.0)
      employment = user.employments.first
      employment.hours_per_week = 20
      employment.save!
      course.save!
    end

    factory :updated_valid_gsi, class: User do
      email
    end

    factory :invalid_gsi, class: User do
      name 'Twinky'
      email ' '
    end

    factory :another_gsi, class: User do
      name 'Sponge Bob Square Pants'
      email
    end
  end
end
