# JSON API controller that serves Sections resource
class SectionsController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: [:index, :clear]

  def assign_model
    @course = Course.includes(:sections, :employments).find(params[:course_id])
    @model = @course.sections.includes(:preferences, :potential_gsis)
  end

  # fixes the problem where ActionController::TestCase::Behavior::post
  # tries to access a non-existend URL helper
  def section_url(course_id)
    course_sections_path(course_id)
  end

  # sets all sections' GSIs to be null
  def clear
    @sections = @model.all
    @sections.update_all('gsi_id = NULL')
    render :index, status: :ok
  end

  def permitted_parameters
    [:name, :lecture, :start_hour, :start_minute,
     :duration_hours, :gsi_id, :weekday, :room]
  end

  include JsonControllerHelper
end
