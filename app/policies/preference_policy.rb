class PreferencePolicy < ApplicationPolicy
  def user_owns_record?
    true
  end
  
  class Scope < Scope
    def resolve
      scope
    end
  end
end
