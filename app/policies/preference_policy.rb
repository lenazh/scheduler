class PreferencePolicy < ApplicationPolicy
  def user_owns_record?
    section = @record.section
    course = section.course
    @user.owns_course?(course) || @record.user_id == @user.id
  end

  def create?
    course = @record.section.course
    @user.owns_course?(course) || @user.teaches_course?(course)
  end
end
