class SectionsController < ApplicationController
  respond_to :json

  def permitted_parameters
    [:name, :lecture, :start_hour, :start_minute, :duration_hours, :gsi_id, :weekday, :room]
  end

  include JsonControllerHelper

end
