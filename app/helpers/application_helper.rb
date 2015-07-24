# Set gon variables for JavaScript for every controller
module ApplicationHelper
  def gon_variables
    {
      courses_api_path: courses_path,
      users_api_path: users_path,

      calendar_start_hour: 6,
      calendar_end_hour: 22,

      courses_view_path: courses_view_path,
      calendar_view_path: calendar_view_path,
      gsi_view_path: gsi_view_path,
      preferences_view_path: preferences_view_path,
      edit_user_registration_path: edit_user_registration_path,
      destroy_user_session_path: destroy_user_session_path
    }
  end

  def set_gon_variables
    gon.push gon_variables
  end

  def password_length
    8
  end
end
