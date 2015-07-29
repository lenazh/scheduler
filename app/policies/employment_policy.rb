class EmploymentPolicy < ApplicationPolicy
  def user_owns_record?
    course = @record.course
    (@user.id == @record.user_id) || @user.owns_course?(course)
  end

  def create?
    course = @record.course
    @user.owns_course?(course)
  end
end
