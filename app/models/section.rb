# Represents a Section of a Class that a GSI can teach
# One section can meet several times per week (at the same time)
# The first digit of the section number represents the lecture number
# (Different lectures are the ones that meet with different professors)
class Section < ActiveRecord::Base
  belongs_to :course
  belongs_to :gsi, class_name: 'User'
  has_many :preferences, dependent: :destroy
  has_many :potential_gsis, through: :preferences, source: :user

  validates :name, presence: true
  validates :room, presence: true
#  validates :lecture, presence: true
  validates :weekday, presence: true
  validates :name, uniqueness: {
    scope: :course_id, message: 'Section name has already been taken' }
  validates :start_hour, presence: true
  validates :start_minute, presence: true
  validates :duration_hours, presence: :true
  validates :start_hour, inclusion: {
    in: 6..22,  message: "Can't be less than 6 or greater than 22" }
  validates :start_minute, inclusion: {
    in: 0..59, message: "Can't be less than 0 or greater than 59" }
  validate :duration_cant_be_longer_than_10hrs_or_negative
  validate :weekdays_are_valid
  validate :workload

  include ActionView::Helpers::TextHelper

  def duration_cant_be_longer_than_10hrs_or_negative
    if (duration_hours > 10) || (duration_hours < 0)
      errors.add :duration_hours, "Can't be longer than 10 hours or negative"
    end
  end

  def weekdays_are_valid
    weekdays = weekday.split(/[ ;,]+/)
    weekdays.each { |weekday| weekday_valid?(weekday) }
  end

  # validates that the GSI doesn't teach more than the maximum allowed workload
  def workload
    return unless gsi
    sections_max = gsi.max_sections_in course
    sections_teaching = gsi.sections_in course
    sections_teaching += 1 unless gsi.appointment_persisted? self
    hours = gsi.hours course
    if sections_teaching > sections_max
      errors.add :gsi, "#{gsi.name} can't teach more than \
      #{pluralize(sections_max, 'section')} (#{pluralize(hours, 'hour')}/week)"
    end
  end

  private

  def weekday_valid?(weekday)
    valid_weekdays = %w(Monday Tuesday Wednesday Thursday Friday)
    unless valid_weekdays.include? weekday
      errors.add :weekday, "#{weekday} is not a valid weekday"
    end
  end
end
