class Employment < ActiveRecord::Base
  belongs_to :gsi, foreign_key: :user_id, class_name: 'User'
  belongs_to :course
end
