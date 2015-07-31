# Tracks GSI employment, namely which users teach which courses
# and how many hours per week they are teaching
class Employment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
end
