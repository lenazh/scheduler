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
    [:preference, :user_id]
  end

  # include JsonControllerHelper

  # locates the preference given section_id
  def get
    get_by_section(params[:section_id])
    authorize(@preference, :show?)
    render :show, status: :ok
  end

  # updates the preference given section_id
  def set
    get_by_section(params[:section_id])
    authorize(@preference, :create?)
    if @preference.set(params[:preference])
      render :show, status: :created
    else
      render json: @preference.errors, status: :unprocessable_entity
    end
  end

  private

  # locates the preference given section_id
  def get_by_section(section_id)
    @preference = Preference.get(current_user.id, section_id)
  end
end
