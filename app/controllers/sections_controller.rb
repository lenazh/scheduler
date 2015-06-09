class SectionsController < ApplicationController
  respond_to :json
  before_action :set_section, only: [:show, :edit, :update, :destroy]

  # GET /sections
  # GET /sections.json
  def index
    @sections = Section.all
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
  end


  # POST /sections
  # POST /sections.json
  def create
    @section = Section.new(section_params)
    if @section.save
      render :show, status: :created, location: @section
    else
      render json: @section.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    if @section.update(section_params)
      render :show, status: :ok, location: @section
    else
      render json: @section.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    @section.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_section
      @section = Section.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(:section).permit(:name, :lecture_id, :start_time, :end_time, :gsi_id, :weekday, :room, :class_id)
    end
end
