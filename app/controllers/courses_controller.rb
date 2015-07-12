class CoursesController < ApplicationController
  respond_to :json

  before_filter :assign_model
  def assign_model; @model = Course; end
  def permitted_parameters; [:name, :user_id]; end
  include JsonControllerHelper
end
