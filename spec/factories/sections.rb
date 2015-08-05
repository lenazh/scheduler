FactoryGirl.define do
  factory :section do
    course
    name '101'
    start_hour 10
    start_minute 0
    duration_hours 2
    gsi_id 0
    weekday 'Wednesday'
    room '115 LeConte'
    lecture '1'

    factory :updated_valid_section, class: Section do
      name '222'
    end
  end

  factory :invalid_section, class: Section do
    course
    name '  '
    start_hour 14
    start_minute 0
    duration_hours 2
    gsi_id 0
    weekday 'Tuesday, Monday'
    room '-'
    lecture '1'
  end

  factory :another_section, class: Section do
    course
    name '333'
    lecture '2'
    start_hour 14
    start_minute 0
    duration_hours 2
    weekday 'Wednesday'
  end

  factory :section_without_course, class: Section do
    name 'Cat grooming'
    lecture '2'
    start_hour 18
    start_minute 10
    duration_hours 1
    weekday 'Monday, Friday'
    room '301 Cat Hall'
  end
end
