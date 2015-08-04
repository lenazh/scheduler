# JSON API controller that serves Sections resource
class PreferencesController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index

  def assign_model
    @course = Course.find(params[:course_id])
    @model = policy_scope(Preference)
  end

  # fixes the problem where ActionController::TestCase::Behavior::post
  # tries to access a non-existend URL helper
  def preference_url(course_id)
    course_preferences_path(course_id)
  end

  def permitted_parameters
    [:preference]
  end

  include JsonControllerHelper
end
