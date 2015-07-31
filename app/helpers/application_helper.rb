# Set gon variables for JavaScript for every controller
module ApplicationHelper
  def set_gon_variables
    gon.push gon_variables
  end

  def password_length
    8
  end

  def gon_variables
    view_paths.merge(api_paths).merge(calendar_parameters)
  end

  def view_paths
    {
      courses_view_path: courses_view_path,
      calendar_view_path: calendar_view_path,
      gsi_view_path: gsi_view_path,
      preferences_view_path: preferences_view_path,
      edit_user_registration_path: edit_user_registration_path,
      destroy_user_session_path: destroy_user_session_path
    }
  end

  def api_paths
    { courses_api_path: courses_path }
  end

  def calendar_parameters
    { calendar_start_hour: 6, calendar_end_hour: 22 }
  end
end
