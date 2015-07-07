FactoryGirl.define do
  factory :course do
    name "8A Physics Berkeley Fall 2015"
    user_id 0

    factory :invalid_course do
      name "  "
    end

    factory :updated_valid_course do
      name "Chemistry 101 Spring 2015"
      user_id 0
    end

    factory :another_course do
      name "Physics For Future Presidents Berkeley Summer 2015"
    end
  end
end
