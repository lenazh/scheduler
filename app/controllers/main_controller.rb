# Serves partials for the AngularJS application routes
class MainController < ApplicationController
  def index; end

  def courses
    render partial: action_name
  end

  def calendar
    render partial: action_name
  end

  def preferences
    render partial: action_name
  end

  def gsi
    render partial: action_name
  end
end
