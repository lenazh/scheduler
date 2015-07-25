# User represents a GSI or a Head GSI
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :courses, dependent: :nullify
  has_many :employments, dependent: :destroy
  has_many :courses_to_teach, through: :employments, source: :course
  has_many :preferences, dependent: :destroy
  has_many :sections, through: :preferences

  validates :name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /[\w\.%+-]+@[\w\.-]+\.[\w\D]{2,4}/ }

  attr_accessor :hours_per_week

  def signed_in_before
    (sign_in_count || 0) > 0
  end
end
