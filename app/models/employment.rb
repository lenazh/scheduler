# Tracks GSI employment, namely which users teach which courses
# and how many hours per week they are teaching
class Employment < ActiveRecord::Base
  belongs_to :gsi, foreign_key: :user_id, class_name: 'User'
  belongs_to :course
end
