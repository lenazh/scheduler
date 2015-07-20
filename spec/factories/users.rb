FactoryGirl.define do
  factory :user do
    name 'Darth Vader'
    email 'vader@gmail.com'

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
    email 'sbsp@nickelodeon.com'
  end
end
