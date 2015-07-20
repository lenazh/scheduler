FactoryGirl.define do  
  factory :gsi, class: User do
    name 'Barney The Dinosaur'
    email 'barney@gmail.com'

    after(:create) do |user|
      course = create(:course)
      user.courses_to_teach << course
      user.sections << create(:section, course: course)
    end

    factory :updated_valid_gsi, class: User do
      email 'vader@deathstar.mil'
    end

    factory :invalid_gsi, class: User do
      name 'Twinky'
      email ' '
    end

    factory :another_gsi, class: User do
      name 'Sponge Bob Square Pants'
      email 'sbsp@nickelodeon.com'
    end
  end
end