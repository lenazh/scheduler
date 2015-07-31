# JSON API controller that serves Sections resource
class AppointmentsController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def assign_model
    @model = policy_scope(Employment)
  end

  def create
    permission_denied
  end

  def update
    permission_denied
  end

  def destroy
    permission_denied
  end

# fixes the problem where ActionController::TestCase::Behavior::post
# tries to access a non-existend URL helper (index and show work just fine :/ )
  def section_url(course_id)
    course_appointments_path(course_id)
  end

  def permitted_parameters
    []
  end

  include JsonControllerHelper
end
