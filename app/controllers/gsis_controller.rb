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
    @gsi.hours_per_week = hours_per_week(@gsi)
  end

# update the nested attributes
  def update
    @gsi = fetch_by_id
    @gsi.hours_per_week = new_hours_per_week || hours_per_week(@gsi)
    update_hours_per_week if hours_per_week_updated
    update_email if email_updated
    render :show, status: :ok, location: @gsi unless performed?
  end

# create the model if such user does not exist
  def create
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
  def destroy
    fetch_by_id
    if @gsi.signed_in_before
      fire(@gsi)
    else
      @gsi.destroy
    end
    head :no_content
  end

# which model parameters is the controller allowed to update
  def permitted_parameters
    [:email]
  end

  private

# Find an existing GSI or creates a new one
  def find_or_create_by(email)
    gsi = User.find_or_create_by(email: email) do |gsi|
      gsi.name = '-'
      password = Devise.friendly_token.first(password_length)
      gsi.password = password
      gsi.password_confirmation = password
    end
    notify_user(gsi)
    gsi
  end


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

# Creates the employment for the gsi
  def hire(gsi, hours_per_week)
    hours_per_week ||= 0
    @course.gsis << gsi
    employment(gsi).hours_per_week = hours_per_week || 0
    employment(gsi).save!
  end

# Removes the employment for the gsi
  def fire(gsi)
    employment(gsi).destroy!
  end

# Whether a new hours/week parameter was passed
  def hours_per_week_updated
    hours = params[:gsi][:hours_per_week]
    hours && (hours != hours_per_week(@gsi))
  end

  def email_updated
    new_email = params[:gsi][:email]
    new_email && (new_email != @gsi.email)
  end

#updates how many hours per week the @gsi works
  def update_employment
    employment(@gsi).hours_per_week = new_hours_per_week
    employment(@gsi).save!
  end

# updates hours per week for the @gsi or hires him/her
  def update_hours_per_week
    if employment(@gsi)
      update_employment
    else
      hire(@gsi, new_hours_per_week)
    end
  end

# sanitizes new hours per week
  def new_hours_per_week
    params[:gsi][:hours_per_week].to_i || 0 
  end

# updates email for an existing user or creates a new one
# if the @gsi has logged in before
  def update_email
    if @gsi.signed_in_before
      fire_old_gsi_hire_new_gsi
    else
      update_existing
    end
  end

# fire the old GSI and hire a new one by email
# for the same number of hours/week
  def fire_old_gsi_hire_new_gsi
    old_gsi = @gsi
    new_gsi = find_or_create_by(params[:gsi][:email])
    if new_gsi.persisted?
      hire(new_gsi, hours_per_week(@gsi))
      fire(old_gsi)
      @gsi = new_gsi
    else
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

# updates the existing GSI's email
  def update_existing
    unless @gsi.update(model_params)
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

# send an email to the user if their password changed
  def notify_user(gsi)
    # Maybe I shouldn't mail things out just yet..
    # GsiMailer.enrollment(@course, gsi).deliver if gsi.password
  end
end
