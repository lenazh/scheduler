# JSON API controller that serves GSIs resource
class GsisController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  include JsonControllerHelper

  # retreives the parent model and the association from the DB
  def assign_model
    @course = policy_scope(Course).find(params[:course_id])
    @model = policy_scope(@course.gsis).eager_load(:employments)
  end

  # make the nested attributes available to the index view
  def index
    super
    @gsis.each do |gsi|
      gsi.hours_per_week = hours_per_week(gsi)
    end
  end

  # make the nested attributes available to the show view
  def show
    super
    @gsi.hours_per_week = hours_per_week(@gsi)
  end

  # update with the nested attributes
  def update
    @gsi = fetch_by_id # has authorize call in it
    authorize Employment.new course_id: @course.id

    @gsi.hours_per_week = new_hours_per_week || hours_per_week(@gsi)
    update_hours_per_week if hours_per_week_updated
    update_email if email_updated
    render :show, status: :ok, location: @gsi unless performed?
  end

  # create the model if such user does not exist
  def create
    authorize User.new email: gsi_params[:email]
    authorize Employment.new course_id: @course.id

    @gsi = find_or_create_by(gsi_params[:email])
    @gsi.hours_per_week = new_hours_per_week

    if @gsi.persisted?
      hire(@gsi, new_hours_per_week)
      render :show, status: :created, location: @gsi
    else
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

  # destroy the model if the user never signed in before
  # and has no other appointments
  def destroy
    fetch_by_id
    authorize Employment.new course_id: @course.id

    if @gsi.signed_in_before || other_appointments?(@gsi)
      fire(@gsi)
    else
      @gsi.destroy!
    end
    head :no_content
  end

  # which model parameters is the controller allowed to update
  def permitted_parameters
    [:email]
  end

  private

  include GsisControllerHelper
end
