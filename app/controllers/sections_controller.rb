class SectionsController < ApplicationController
  respond_to :json

  def permitted_parameters
    [:name, :lecture_id, :start_time, :end_time, :gsi_id, :weekday, :room, :class_id]
  end

  include JsonControllerHelper

end
