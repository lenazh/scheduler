# Access policies for User/Gsi resource
class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    true
  end

  def update?
    user_owns_record?
  end

  def destroy?
    user_owns_record?
  end

  def user_owns_record?
    return false if @record.signed_in_before
    return false if @record.appointments_count > 0
    true
  end
end
