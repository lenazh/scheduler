# JSON API controller that serves GSIs resource
class EmploymentsController < ApplicationController
  respond_to :json
  before_filter :assign_model
  after_action :verify_authorized, except: :index

  include JsonControllerHelper

  # retreives the parent model and the association from the DB
  def assign_model
    @course = policy_scope(Course).find(params[:course_id])
    @model = EmploymentPolicy::Scope.
      new(current_user, Employment).resolve_employments(@course)
  end

  def create
    new_employment = @model.new(model_params)
    authorize new_employment
    @employment = new_employment
    @employment.hours_per_week = model_params[:hours_per_week]
    save_and_render
  end

  def update
    @employment = fetch_by_id # has authorize call in it
    old_gsi = @employment.gsi
    @employment.hours_per_week = model_params[:hours_per_week]
    save_and_render
    destroy_if_needed(old_gsi)
  end

  def destroy
    fetch_by_id # has authorize call in it
    old_gsi = @employment.gsi
    @employment.destroy
    destroy_if_needed(old_gsi)
    head :no_content
  end

  # which model parameters is the controller allowed to update
  def permitted_parameters
    [:hours_per_week]
  end

  private

  def gsi_params
    params.require(:employment).permit(:email)
  end

  # saves the record and renders the result status
  def save_and_render
    if assign_gsi && @employment.save
      render :show,
             status: :ok,
             location: course_employment_url(@course.id, @employment.id)
    else
      render json: singular.errors, status: :unprocessable_entity
    end
  end

  # assigns a correct GSI for the current record given email
  # Returns true if the GSI was successfully assigned and false otherwise
  def assign_gsi
    gsi = find_or_create_by(gsi_params[:email])
    return false unless gsi.persisted?
    @employment.gsi = gsi
    true
  end

  # destroys a user record if he/she never logged in and has no
  # other appointments
  def destroy_if_needed(gsi)
    return if gsi.signed_in_before || has_appointments?(gsi)
    authorize gsi, :destroy?
    gsi.destroy!
  end

  # checks if the GSI has appointments
  def has_appointments?(gsi)
    gsi.appointments_count > 0
  end

  # Returns an existing GSI or a new one
  def find_or_create_by(email)
    authorize User.new, :show?
    User.find_or_create_by(email: email) do |user|
      authorize User.new, :create?
      user.name = email.match(/^(.+)?@.*$/)[1]
      password = Devise.friendly_token.first(password_length)
      user.password = password
      user.password_confirmation = password
      notify_user(user)
    end
  end

  # send an email to the user if their password changed
  def notify_user(_gsi)
    puts 'New GSI created'
    puts "Email: #{_gsi.email}"
    puts "Password: #{_gsi.password}"
    # GsiMailer.enrollment(@course, _gsi).deliver if gsi.password
  end
end
