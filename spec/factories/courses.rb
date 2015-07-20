FactoryGirl.define do
  factory :course do
    user
    name '8A Physics Berkeley Fall 2015'
  end

  factory :invalid_course, class: Course do
    user
    name '  '
  end

  factory :updated_valid_course, class: Course do
    user
    name 'Chemistry 101 Spring 2015'
    user_id 0
  end

  factory :another_course, class: Course do
    user
    name 'Physics For Future Presidents Berkeley Summer 2015'
  end

  factory :course_with_no_owner, class: Course do
    name 'Kerbology 101'
  end
end
