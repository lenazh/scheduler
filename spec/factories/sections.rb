FactoryGirl.define do
  factory :section do
    name "101"
    lecture_id 1
    start_time "10:00"
    end_time "12:00"
    gsi_id 0
    weekday 5
    room "115 LeConte"
    class_id 1

    factory :invalid_section do
      name "  "
    end

    factory :updated_valid_section do
      name "222"
    end

  end


end
