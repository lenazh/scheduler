class UsersController < ApplicationController
  respond_to :json

  before_filter :assign_model
  def assign_model; @model = User; end
  def permitted_parameters; [:name, :email]; end
  include JsonControllerHelper
end
