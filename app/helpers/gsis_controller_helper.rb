# Temporary location for helper methods of GSIs controller
# TODO: refactoring - most of this logic should be in a model
# maybe User or Gsi << User or something like that
# This logic needs a major redesign
# employment(gsi) has possible DoS issues
module GsisControllerHelper
# Find an existing GSI or creates a new one
  def find_or_create_by(email)
    gsi = User.find_or_create_by(email: email) do |user|
      user.name = '-'
      password = Devise.friendly_token.first(password_length)
      user.password = password
      user.password_confirmation = password
    end
    notify_user(gsi)
    gsi
  end

# returns Employment join model of @gsi and @course
# the point of iterating manually is to not make additional
# SQL queries since employments table is eagerly loaded
#
# TODO: Potential DoS here if someone creates a course
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
    hours || 0
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

# updates how many hours per week the @gsi works
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
    return nil unless params[:gsi][:hours_per_week]
    params[:gsi][:hours_per_week].to_i || 0
  end

# updates email for an existing user or creates a new one
# if the @gsi has logged in before or has other appointments
  def update_email
    if @gsi.signed_in_before || other_appointments?(@gsi)
      fire_old_gsi_hire_new_gsi
    else
      destroy_old_gsi_hire_new_gsi
    end
  end

# fire the old GSI and hire a new one by email
# for the same number of hours/week
  def fire_old_gsi_hire_new_gsi
    old_gsi = @gsi
    new_gsi = find_or_create_by(params[:gsi][:email])
    if new_gsi.persisted?
      hours = hours_per_week(old_gsi)
      hire_and_fire(new_gsi, old_gsi, hours)
    else
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

  def hire_and_fire(new_gsi, old_gsi, hours)
    hire(new_gsi, hours)
    fire(old_gsi)
    @gsi = new_gsi
    @gsi.hours_per_week = hours
  end

# destroy the old GSI and hire a new one by email
# for the same number of hours/week
  def destroy_old_gsi_hire_new_gsi
    old_gsi = @gsi
    new_gsi = User.find_by(email: params[:gsi][:email])
    if new_gsi
      hours = hours_per_week(old_gsi)
      hire_and_destroy(new_gsi, old_gsi, hours)
    else
      update_existing_email
    end
  end

  def hire_and_destroy(new_gsi, old_gsi, hours)
    hire(new_gsi, hours)
    old_gsi.destroy!
    @gsi = new_gsi
    @gsi.hours_per_week = hours
  end

# updates the existing GSI's email
  def update_existing_email
    unless @gsi.update(model_params)
      render json: @gsi.errors, status: :unprocessable_entity
    end
  end

# checks if the GSI has appointments other than this one
  def other_appointments?(gsi)
    gsi.appointments_count > 1
  end

# send an email to the user if their password changed
  def notify_user(gsi)
    # Maybe I shouldn't mail things out just yet..
    # GsiMailer.enrollment(@course, gsi).deliver if gsi.password
  end
end
