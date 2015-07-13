# Tracks how much each GSI would prefer to teach his/her
# available sections. Preference is a number 0..1, where
# 0 means that the GSI can't teach this section
class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
end
