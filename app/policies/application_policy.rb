# Default access policies for all resources, except the
# controlllers that serve static pages
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    fail Pundit::NotAuthorizedError, 'Must be logged in' unless user
    @user = user
    @record = record
  end

  def create?
    user_owns_record?
  end

  def update?
    user_owns_record?
  end

  def destroy?
    user_owns_record?
  end

  def show?
    user_owns_record?
  end

  def new?
    create?
  end

  def edit?
    update?
  end

  def user_owns_record?
    false
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # returns scope for the @user
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
