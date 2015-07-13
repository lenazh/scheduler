shared_examples 'a JSON resource controller:' do

  # singular downcase string of the class name
  let(:model_string) { model_class.to_s.underscore }

  # singular downcase symbol of the class name
  let(:model_symbol) { model_string.to_sym }

  # minimal set of attributes required to create an invalid model
  let(:invalid_attributes) do
    attributes_for "invalid_#{model_string}".to_sym
  end

  # set of valid attributes required to update model
  let(:updated_valid_attributes) do
    attributes_for "updated_valid_#{model_string}".to_sym
  end

  # set of invalid attributes required to update model
  let(:updated_invalid_attributes) do
    attributes_for "invalid_#{model_string}".to_sym
  end

  # symbol of the variable being assigned by the
  # controller in all the other methods
  let(:assigned_variable) { model_symbol }

  # symbol of the variable being assigned by the RESTful
  # controller in the index method
  let(:mass_assigned_variable) { model_string.pluralize.to_sym }

  describe 'GET index' do
    it 'assigns all models as @models' do
      model = model_class.create! valid_attributes
      get :index, request_params, valid_session
      assigns(mass_assigned_variable).should eq([model])
    end
  end

  describe 'GET show' do
    it 'assigns the requested model as @model' do
      model = model_class.create! valid_attributes
      get :show, request_params(id: model.to_param), valid_session
      assigns(assigned_variable).should eq(model)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new model_class' do
        expect do
          post :create,
               request_params(assigned_variable => valid_attributes),
               valid_session
        end.to change(model_class, :count).by(1)
      end

      it 'assigns a newly created course as @course' do
        post :create,
             request_params(assigned_variable => valid_attributes),
             valid_session
        assigns(assigned_variable).should be_a(model_class)
        assigns(assigned_variable).should be_persisted
      end

      it 'returns :created code' do
        post :create,
             request_params(assigned_variable => valid_attributes),
             valid_session
        expect(response.response_code).to eq(code(:created))
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved course as @course' do
        # Trigger the behavior that occurs when invalid params are submitted
        model_class.any_instance.stub(:save).and_return(false)
        post :create,
             request_params(assigned_variable => invalid_attributes),
             valid_session
        assigns(assigned_variable).should be_a_new(model_class)
      end

      it 'returns :unprocessable_entity code' do
        # Trigger the behavior that occurs when invalid params are submitted
        model_class.any_instance.stub(:save).and_return(false)
        post :create,
             request_params(assigned_variable => invalid_attributes),
             valid_session
        expect(response.response_code).to eq(code(:unprocessable_entity))
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested model' do
        model = model_class.create! valid_attributes
        # Assuming there are no other models in the database, this
        # specifies that the model_class created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        model_class.any_instance.should_receive(:update)
          .with(updated_valid_attributes.stringify_keys)
        put :update,
            request_params(
              id: model.to_param,
              assigned_variable => updated_valid_attributes),
            valid_session
      end

      it 'assigns the requested model as @model' do
        model = model_class.create! valid_attributes
        put :update,
            request_params(
              id: model.to_param,
              assigned_variable => valid_attributes),
            valid_session
        assigns(assigned_variable).should eq(model)
      end

      it 'returns success code' do
        model = model_class.create! valid_attributes
        put :update,
            request_params(
              id: model.to_param,
              assigned_variable => valid_attributes),
            valid_session
        response.should be_success
      end
    end

    describe 'with invalid params' do
      it 'assigns the model as @model' do
        model = model_class.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        model_class.any_instance.stub(:save).and_return(false)
        put :update,
            request_params(
              id: model.to_param,
              assigned_variable => updated_invalid_attributes),
            valid_session
        assigns(assigned_variable).should eq(model)
      end

      it 'returns :unprocessable_entity code' do
        model = model_class.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        model_class.any_instance.stub(:save).and_return(false)
        put :update,
            request_params(
              id: model.to_param,
              assigned_variable => updated_invalid_attributes),
            valid_session
        expect(response.response_code).to eq(code(:unprocessable_entity))
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested model' do
      model = model_class.create! valid_attributes
      expect do
        delete :destroy, request_params(id: model.to_param), valid_session
      end.to change(model_class, :count).by(-1)
    end

    it 'returns :no_content code' do
      model = model_class.create! valid_attributes
      delete :destroy, request_params(id: model.to_param), valid_session
      expect(response.response_code).to eq(code(:no_content))
    end
  end

private

  def code(code)
    Rack::Utils::SYMBOL_TO_STATUS_CODE[code]
  end

  def nested_resource
    !((defined?(parent)).nil?)
  end

  let(:parent_name) { parent.class.to_s.underscore }
  let(:foreign_key) { (parent_name + '_id').to_sym }

  def request_params(hash = {})
    hash[:format] = :json
    return hash unless nested_resource
    hash[foreign_key] = parent.id
    hash
  end

 # minimal set of attributes required to create a valid model
  def valid_attributes
    attributes = attributes_for model_symbol
    return attributes unless nested_resource
    attributes[foreign_key] = parent.id
    attributes
  end

end
