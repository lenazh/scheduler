# TODO: disallow head GSIs to update GSIs names and emails
# after they logged in for the first time!
# JSON API controller that serves GSIs resource
class GsisController < ApplicationController
  respond_to :json
  before_filter :assign_model
  before_filter :create, only: [:create]
  after_filter :update_nested, only: [:update]
  after_filter :assign_nested_index, only: [:index]
  after_filter :assign_nested_show, only: [:show]

# retreives the parent model and the association from the DB
  def assign_model
    @course = Course.find(params[:course_id])
    @model = @course.gsis.eager_load(:employments)
  end

# make the nested attributes available to the index view
  def assign_nested_index
    @gsis.each do |gsi|
      gsi.hours_per_week = hours_per_week(gsi)
    end
  end

# make the nested attributes available to the show view
  def assign_nested_show
    @gsi.hours_per_week = hours_per_week(@gsi)
  end

# update the nested attributes
  def update_nested
    return unless @gsi.valid?
    return unless employment(@gsi)
    employment(@gsi).hours_per_week = assigned_hours_per_week
    employment(@gsi).save!
  end

# create the model if such user does not exist
  def create
    @gsi = User.find_or_create_by(email: gsi_params[:email]) do |gsi|
      gsi.name = gsi_params[:name]
    end

    if @gsi.persisted?
      @course.gsis << @gsi
      update_nested
      render :show, status: :created, location: @gsi
    else
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

  def permitted_parameters
    [:name, :email]
  end

  include JsonControllerHelper

  private

# returns Employment join model of @gsi and @course
  def employment(gsi)
    gsi.employments.each do |employment|
      return employment if employment.course_id == @course.id
    end
    nil
  end

# Returns current hours per week the gsi works
  def hours_per_week(gsi)
    hours = employment(gsi) ? employment(gsi).hours_per_week : 0
    hours ||= 0
  end

# Returns the permitted assign parameters on gsi model
  def gsi_params
    params.require(:gsi).permit(*permitted_parameters)
  end

# Returns how many hours per week we want to set for this gsi
  def assigned_hours_per_week
    if defined?(params[:gsi][:hours_per_week]) != nil
      params[:gsi][:hours_per_week]
    else
      0
    end
  end
end
