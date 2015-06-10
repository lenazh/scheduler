class CoursesController < ApplicationController
  respond_to :json

  def permitted_parameters; [:name, :user_id]; end

  include JsonControllerHelper
end
