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


  # returns true if this person ever signed in and false otherwise
  def signed_in_before
    (sign_in_count || 0) > 0
  end

  # returns how many appointments this person has
  def appointments_count
    Employment.where('user_id = ?', id).count
  end

  # returns whether the user is teaching for the course
  def teaching_course?(course)
    return false unless course
    Employment.exists?(['course_id = ? AND user_id = ?', course.id, id])
  end

  # returns whether the user is teaching the section
  def teaches_section?(section)
    return false unless section
    section.gsi.id == id
  end

  # returns whether the user is a head gsi for the course
  def owns_course?(course)
    return false unless course
    course.user_id == id
  end

  # returns whether the user is a head gsi for the course that
  # includes this section
  def owns_section?(section)
    return false unless section
    owns_course?(section.course)
  end
end
