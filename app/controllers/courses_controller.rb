# JSON API controller that serves Courses resource
class CoursesController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index

  def assign_model
    @model = Course.where(user_id: current_user.id)
    # @model = policy_scope(Course) causes a Runtime circular dependency?
  end

  def permitted_parameters
    [:name, :user_id]
  end

  include JsonControllerHelper
end
