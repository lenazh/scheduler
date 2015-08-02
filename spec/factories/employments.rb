FactoryGirl.define do
  factory :employment do
    association :gsi, factory: :user
    course
    hours_per_week 20

    factory :another_employment, class: Employment do
      hours_per_week 10
    end
  end
end
