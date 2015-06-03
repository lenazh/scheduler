class Section < ActiveRecord::Base
  validates :name, presence: true
  validates :room, presence: true
  validates :name, uniquness: { scope: :class_id}
  validate :cannot_end_before_it_starts

  def cannot_end_before_it_starts
    
  end
end
