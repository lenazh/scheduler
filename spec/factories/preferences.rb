FactoryGirl.define do
  factory :preference do
    user
    section
    preference 0.5

    factory :updated_valid_preference, class: Preference do
      preference 0.3
    end

    factory :another_preference, class: Preference do
      preference 1.0
    end

    factory :invalid_preference, class: Preference do
      preference -1
    end
  end
end
