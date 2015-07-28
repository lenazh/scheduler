# JSON API controller that serves Courses resource
class CoursesController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def assign_model
    @model = policy_scope(Course)
  end

  def permitted_parameters
    [:name, :user_id]
  end

  include JsonControllerHelper
end
