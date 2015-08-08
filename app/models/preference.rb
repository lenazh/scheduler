# Tracks how much each GSI would prefer to teach his/her
# available sections. Preference is a number 0..1, where
# 0 means that the GSI can't teach this section
class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :section

  validates :user, presence: true
  validates :section, presence: true
  validate :between_0_and_1

  # returns true if successful false otherwise
  def set(preference)
    if (preference.to_f == 0)
      destroy! if id
      true
    else
      self.preference = preference
      save
    end
  end

  # returns the record by user_id and section_id
  # if the record doesn't exist returns a new unsaved record
  def self.get(user_id, section_id)
    record = Preference.where(
      'section_id = ? AND user_id = ?', section_id, user_id).first
    record || Preference.new(
      preference: 0,section_id: section_id, user_id: user_id)
  end

  # validates if the preference is in (0; 1] interval
  def between_0_and_1
    unless (preference > 0) && (preference <= 1)
      errors.add :preference, 'has to be in (0; 1] interval'
    end
  end
end
