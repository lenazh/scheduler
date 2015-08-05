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

  def get
    find_preference
    authorize(@preference, :show?)
    render :show, status: :ok
  end

  def set
    find_preference
    authorize(@preference, :create?)
    @preference.preference = params[:preference]
    if @preference.save
      render :show,
        status: :created,
        location: course_preference_path(@course.id, @preference.id)
    else
      render json: @preference.errors, status: :unprocessable_entity
    end
  end

  private

  def find_preference()
    # find_or_create_by is not used to keep get() safe
    section_id = params[:section_id].to_i
    user_id = current_user.id
    @preference = @model.
      where('section_id = ? AND user_id = ?', section_id, user_id).first
    @preference ||= Preference.new preference: 0,
                                   section_id: section_id,
                                   user_id: user_id
  end
end
