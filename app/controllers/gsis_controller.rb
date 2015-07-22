# TODO: disallow head GSIs to update GSIs emails
# after they logged in for the first time!
# JSON API controller that serves GSIs resource
class GsisController < ApplicationController
  respond_to :json
  before_filter :assign_model

  include JsonControllerHelper

# retreives the parent model and the association from the DB
  def assign_model
    @course = Course.find(params[:course_id])
    @model = @course.gsis.eager_load(:employments)
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
    @hours_per_week = hours_per_week(@gsi)
  end

# update the nested attributes
  def update
    @hours_per_week = new_hours_per_week if new_hours_per_week_assigned
    super
    return unless new_hours_per_week_assigned
    if employment(@gsi)
      update_employment
    else
      hire_gsi(new_hours_per_week)
    end
  end

# create the model if such user does not exist
  def create
    @gsi = User.find_or_create_by(email: gsi_params[:email]) do |gsi|
      gsi.name = '-'
      # we don't know the name before the GSI logs in for the 1st time
    end

    if @gsi.persisted?
      hire_gsi(new_hours_per_week)
      @hours_per_week = new_hours_per_week
      render :show, status: :created, location: @gsi
    else
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

  def permitted_parameters
    [:email]
  end

  private

# returns Employment join model of @gsi and @course
# the point of iterating manually is to not make additional
# SQL queries since employments table is eagerly loaded
#
# TODO: Potential DOS here if someone creates a course
# with a lot of GSIs
  def employment(gsi)
    gsi.employments.each do |employment|
      return employment if employment.course_id == @course.id
    end
    nil
  end

# Returns current hours per week the gsi works
  def hours_per_week(gsi)
    employment(gsi).hours_per_week
    hours = employment(gsi) ? employment(gsi).hours_per_week : 0
    hours ||= 0
  end

# Returns the permitted assign parameters on gsi model
  def gsi_params
    params.require(:gsi).permit(*permitted_parameters)
  end

# Creates the employment for the new or existing @gsi
  def hire_gsi(hours_per_week)
    hours_per_week ||= 0
    @course.gsis << @gsi
    employment(@gsi).hours_per_week = hours_per_week || 0
    employment(@gsi).save!
  end

# Whether a new hours/week parameter was passed
  def new_hours_per_week_assigned
    params[:gsi][:hours_per_week]
  end

#updates how many hours per week the @gsi works
  def update_employment
    employment(@gsi).hours_per_week = new_hours_per_week
    employment(@gsi).save!
  end

# sanitizes new hours per week
  def new_hours_per_week
    puts "params[:gsi][:hours_per_week] = #{params[:gsi][:hours_per_week]}"
    puts "params[:gsi][:hours_per_week].to_i = #{params[:gsi][:hours_per_week].to_i}"
    params[:gsi][:hours_per_week].to_i || 0 
  end
end
