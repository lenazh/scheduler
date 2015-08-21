# Access policies for Section resource
class SectionPolicy < ApplicationPolicy
  def user_owns_record?
    return false unless @record.course
    @record.course.user_id == @user.id
  end
end
