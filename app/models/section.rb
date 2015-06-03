class Section < ActiveRecord::Base
  validates :name, presence: true
  validates :room, presence: true
  validates :name, uniqueness: { scope: :class_id}
  validate :cannot_end_before_it_starts

  def cannot_end_before_it_starts
    if start_time > end_time
      msg = "can't end before it starts"
      errors.add :end_time, msg
      errors.add :start_time, msg
    end
  end
end
