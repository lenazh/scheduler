FactoryGirl.define do
  factory :user do
    name 'Darth Vader'
    email 'vader@gmail.com'

    factory :updated_valid_user do
      email 'vader@deathstar.mil'
    end

    factory :invalid_user do
      email ' '
    end

    factory :another_user do
      name 'Sponge Bob Square Pants'
      email 'sbsp@nickelodeon.com'
    end
  end
end
