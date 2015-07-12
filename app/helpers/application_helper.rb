module ApplicationHelper

  def gon_variables
    {
      courses_api_path: courses_path,
      users_api_path: users_path,

      courses_view_path: courses_view_path,
      calendar_view_path: calendar_view_path,
      gsi_view_path: gsi_view_path,
      preferences_view_path: preferences_view_path
    }
  end

  def set_gon_variables
    gon.push gon_variables
  end

end
