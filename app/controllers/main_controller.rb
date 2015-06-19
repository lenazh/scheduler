class MainController < ApplicationController
  def index
  end

  def courses
    render_partial
  end

  def calendar
    render_partial
  end

  def preferences
    render_partial
  end

  def gsi
    render_partial
  end

private
  def render_partial
    render :partial => action_name
  end

end
