module JsonControllerHelper

  # GET /model
  # GET /model.json
  def index
    self.plural = @model.all
  end

  # GET /model/1
  # GET /model/1.json
  def show
    fetch_by_id
  end

  # POST /model
  # POST /model.json
  def create
    self.singular = @model.new(model_params)
    if singular.save
      render :show, status: :created, location: singular
    else
      render json: singular.errors, status: :unprocessable_entity 
    end
  end

  # PATCH/PUT /model/1
  # PATCH/PUT /model/1.json
  def update
    fetch_by_id
    if singular.update(model_params)
      render :show, status: :ok, location: singular
    else
      render json: singular.errors, status: :unprocessable_entity
    end
  end

  # DELETE /model/1
  # DELETE /model/1.json
  def destroy
    fetch_by_id
    singular.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def fetch_by_id
      self.singular = @model.find(params[:id])
    end

    # Returns the variable for the view that the retrieved model was assigned to
    def singular; eval("@#{controller_name.singularize}"); end

    # Assigns the variable for the view for the single retrieved model
    def singular=(param); eval("@#{controller_name.singularize}=param"); end

    # Assigns the variable for the view for multiple retrieved models
    def plural=(param); eval("@#{controller_name}=param"); end

    # Corresponding model name as a symbol
    def variable_symbol; controller_name.singularize.to_sym; end

    # Never trust parameters from the scary internet, only allow the white list through.
    def model_params
      params.require(variable_symbol).permit(*permitted_parameters)
    end
end