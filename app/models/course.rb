# Represents course that belongs to a head GSI
# and has several gsi's teaching it
class Course < ActiveRecord::Base
  belongs_to :user
  has_many :sections, dependent: :destroy
  has_many :employments, dependent: :destroy
  has_many :gsis, through: :employments, class_name: 'User'
  validates :name, presence: true
end
