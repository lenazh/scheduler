FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@gmail.com"
  end

  factory :user do
    name 'Darth Vader'
    email

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
    name 'Barney The Dinosaur'
    email

    after(:create) do |user|
      course = create(:course)
      user.courses_to_teach << course
      user.sections << create(:section, course: course)
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
