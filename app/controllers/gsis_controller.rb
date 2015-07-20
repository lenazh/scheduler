# JSON API controller that serves GSIs resource
class GsisController < ApplicationController
  respond_to :json
  before_filter :assign_model

  def assign_model
    @course = Course.includes(:sections).find(params[:course_id])
    @model = @course.gsis
  end

  def permitted_parameters
    [:name, :email]
  end

  include JsonControllerHelper
end
