# Access policies for Course resource
class CoursePolicy < ApplicationPolicy
  def user_owns_record?
    @record.user_id == @user.id
  end

  # Returns all courses that belong to @user
  class Scope < Scope
    def resolve
      scope.where(user_id: @user.id)
    end
  end
end
