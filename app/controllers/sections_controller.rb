class SectionsController < ApplicationController
  respond_to :json

  def permitted_parameters
    [:name, :lecture, :start_time, :end_time, :gsi_id, :weekday, :room, :course_id]
  end

  include JsonControllerHelper

end
