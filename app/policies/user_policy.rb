class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def user_owns_record?
    return false if @record.signed_in_before
    return false if @record.appointments_count > 1
    return false unless @record.courses_to_teach.first.user_id == @user.id
    true
  end
end
