module JsonControllerHelper

  # GET /sections
  # GET /sections.json
  def index
    self.plural = my_class.all
  end

  # GET /sections/1
  # GET /sections/1.json
  def show
    fetch_singular
  end

  # POST /sections
  # POST /sections.json
  def create
    self.singular = my_class.new(section_params)
    if singular.save
      render :show, status: :created, location: singular
    else
      render json: singular.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /sections/1
  # PATCH/PUT /sections/1.json
  def update
    fetch_singular
    if singular.update(section_params)
      render :show, status: :ok, location: singular
    else
      render json: singular.errors, status: :unprocessable_entity
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.json
  def destroy
    fetch_singular
    singular.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def fetch_singular
      self.singular = my_class.find(params[:id])
    end

    # Returns the class of the corresponding model
    def my_class; controller_name.classify.constantize; end

    # Returns the variable for the view that the retrieved model was assigned to
    def singular; eval("@#{controller_name.singularize}"); end

    # Assigns the variable for the view for the single retrieved model
    def singular=(param); eval("@#{controller_name.singularize}=param"); end

    # Assigns the variable for the view for multiple retrieved models
    def plural=(param); eval("@#{controller_name}=param"); end

    # Corresponding model name as a symbol
    def variable_symbol; controller_name.singularize.to_sym; end

    # Never trust parameters from the scary internet, only allow the white list through.
    def section_params
      params.require(variable_symbol).permit(*permitted_parameters)
    end
end