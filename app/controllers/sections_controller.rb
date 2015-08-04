# JSON API controller that serves Sections resource
class SectionsController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def assign_model
    @course = Course.find(params[:course_id])
    @model = policy_scope(@course.sections)
  end

# fixes the problem where ActionController::TestCase::Behavior::post
# tries to access a non-existend URL helper
  def section_url(course_id)
    course_sections_path(course_id)
  end

  def permitted_parameters
    [:name, :lecture, :start_hour, :start_minute,
     :duration_hours, :gsi_id, :weekday, :room]
  end

  include JsonControllerHelper
end
