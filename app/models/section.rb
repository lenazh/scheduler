class Section < ActiveRecord::Base
  belongs_to :course
  belongs_to :gsi, class_name: 'User'
  has_many :preferences, dependent: :destroy
  has_many :potential_gsis, through: :preferences, source: :user

  validates :name, presence: true
  validates :room, presence: true
  validates :lecture, presence: true
  validates :weekday, presence: true
  validates :name, uniqueness: { scope: :course_id}
  validates :start_hour, presence: true
  validates :start_minute, presence: true
  validates :duration_hours, presence: :true
  validates :start_hour, inclusion: { in: 0..23 }
  validates :start_minute, inclusion: { in: 0..59 }
  validate :duration_cant_be_longer_than_10hrs_or_negative

  def duration_cant_be_longer_than_10hrs_or_negative
    if (duration_hours > 10) || (duration_hours < 0)
      errors.add :duration_hours, "Can't be longer than 10 hours or negative"
    end
  end


end
