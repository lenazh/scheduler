FactoryGirl.define do
  factory :course do
    name "8A Physics Berkeley Fall 2015"
    user_id 1

    factory :invalid_course do
      name "  "
    end

    factory :updated_valid_course do
      name "Chemistry 101 Spring 2015"
      user_id 2
    end

  end
end
