class Course < ActiveRecord::Base
  belongs_to :user
  has_many :sections
  has_many :employments
  has_many :gsis, through: :employments, class_name: 'User'

  validates :name, presence: true
end
