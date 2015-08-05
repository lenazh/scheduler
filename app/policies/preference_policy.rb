# Access policies for Preference resource
class PreferencePolicy < ApplicationPolicy
  def user_owns_record?
    section = @record.section
    return false unless section
    course = section.course
    @user.owns_course?(course) || @record.user_id == @user.id
  end

  def create?
    section = Section.find(@record.section_id)
    course = section.course
    @user.owns_course?(course) || @user.teaching_course?(course)
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
