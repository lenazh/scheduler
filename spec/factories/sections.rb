FactoryGirl.define do
  factory :section do
    name '101'
    start_hour 10
    start_minute 0
    duration_hours 2
    gsi_id 0
    weekday 'Wednesday'
    room '115 LeConte'
    lecture '1'
    factory :invalid_section do
      name '  '
    end

    factory :updated_valid_section do
      name '222'
    end

    factory :another_section do
      name '333'
      lecture '2'
      start_hour 14
      start_minute 0
      duration_hours 2
    end
  end
end
