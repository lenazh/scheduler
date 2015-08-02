# Access policies for Employment resource
class EmploymentPolicy < ApplicationPolicy
  def user_owns_record?
    course = @record.course
    (@user.id == @record.user_id) || @user.owns_course?(course)
  end

  def create?
    course = @record.course
    @user.owns_course?(course)
  end

  # Returns all Employments that are part of the course
  class Scope < Scope
    def resolve_employments(course)
      scope.includes(:gsi).where(course_id: course.id)
    end

    def resolve_appointments
      scope.includes(:course).where(user_id: @user.id)
    end
  end
end
