class UsersController < ApplicationController
  respond_to :json

  def permitted_parameters
    [:name, :email]
  end

  include JsonControllerHelper

end
