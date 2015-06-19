module ApplicationHelper
  def set_gon_variables
    gon.push({
      courses_api_path: courses_path,
      sections_api_path: sections_path,
      gsis_api_path: "none",

      courses_view_path: courses_view_path,
      calendar_view_path: calendar_view_path,
      gsi_view_path: gsi_view_path,
      preferences_view_path: preferences_view_path
    })
  end
end
