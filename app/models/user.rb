class User < ActiveRecord::Base
  has_many :courses, dependent: :nullify
  has_many :employments, dependent: :destroy
  has_many :courses_to_teach, through: :employment, foreign_key: :gsi_id
  has_many :preferences, dependent: :destroy
  has_many :sections, through: :preferences

  validates :name, presence: true
  validates :email, presence: true
  validates :email, format: {with: /[\w\.%+-]+@[\w\.-]+\.[\w\D]{2,4}/}
end
