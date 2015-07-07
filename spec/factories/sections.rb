FactoryGirl.define do
  factory :section do
    name "101"
    course_id 1
    start_time "2000-01-01T10:00:00.000Z"
    end_time "2000-01-01T12:00:00.000Z"
    gsi_id 0
    weekday 5
    room "115 LeConte"
    lecture "1"
    factory :invalid_section do
      name "  "
    end

    factory :updated_valid_section do
      name "222"
    end

    factory :another_section do
      name "333"
      lecture "2"
      start_time "2000-01-01T14:00:00.000Z"
      end_time "2000-01-01T16:00:00.000Z"
    end


  end


end
