shared_examples 'a JSON resource controller:' do

  # singular downcase string of the factory name
  let(:factory_name) { factory.to_s }

  # minimal set of attributes required to create a valid model
  let(:valid_attributes) { attributes_for factory }

  # minimal set of attributes required to create an invalid model
  let(:invalid_attributes) do
    attributes_for "invalid_#{factory_name}".to_sym
  end

  # set of valid attributes required to update model
  let(:updated_valid_attributes) do
    attributes_for "updated_valid_#{factory_name}".to_sym
  end

  # set of invalid attributes required to update model
  let(:updated_invalid_attributes) do
    attributes_for "invalid_#{factory_name}".to_sym
  end

  # symbol of the variable being assigned by the
  # controller in all the other methods
  let(:assigned_variable) { factory }

  # symbol of the variable being assigned by the RESTful
  # controller in the index method
  let(:mass_assigned_variable) { factory_name.pluralize.to_sym }

  let(:model) { FactoryGirl.create(factory) }

  describe 'GET index' do
    it 'assigns all models as @models' do
      get :index, request_params(model), valid_session
      assigns(mass_assigned_variable).should eq([model])
    end
  end

  describe 'GET show' do
    it 'assigns the requested model as @model' do
      get :show, request_params(model, id: model.to_param), valid_session
      assigns(assigned_variable).should eq(model)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new model' do
        sample_model = FactoryGirl.build(factory)
        expect do
          post :create,
               request_params(nil, assigned_variable => valid_attributes),
               valid_session
        end.to change(sample_model.class, :count).by(1)
      end

      it 'assigns a newly created model as @model' do
        sample_model = FactoryGirl.build(factory)
        post :create,
             request_params(nil, assigned_variable => valid_attributes),
             valid_session
        assigns(assigned_variable).should be_a(sample_model.class)
        assigns(assigned_variable).should be_persisted
      end

      it 'returns :created code' do
        post :create,
             request_params(nil, assigned_variable => valid_attributes),
             valid_session
        expect(response.response_code).to eq(code(:created))
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved model as @model' do
        # Trigger the behavior that occurs when invalid params are submitted
        model.class.any_instance.stub(:save).and_return(false)
        post :create,
             request_params(model, assigned_variable => invalid_attributes),
             valid_session
        assigns(assigned_variable).should be_a_new(model.class)
      end

      it 'returns :unprocessable_entity code' do
        # Trigger the behavior that occurs when invalid params are submitted
        model.class.any_instance.stub(:save).and_return(false)
        post :create,
             request_params(model, assigned_variable => invalid_attributes),
             valid_session
        expect(response.response_code).to eq(code(:unprocessable_entity))
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested model' do
        # Assuming there are no other models in the database, this
        # specifies that the model.class created in before(:each) block
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        model.class.any_instance.should_receive(:update)
          .with(updated_valid_attributes.stringify_keys)
        put :update,
            request_params(
              model,
              id: model.to_param,
              assigned_variable => updated_valid_attributes),
            valid_session
      end

      it 'assigns the requested model as @model' do
        put :update,
            request_params(
              model,
              id: model.to_param,
              assigned_variable => valid_attributes),
            valid_session
        assigns(assigned_variable).should eq(model)
      end

      it 'returns success code' do
        put :update,
            request_params(
              model,
              id: model.to_param,
              assigned_variable => valid_attributes),
            valid_session
        response.should be_success
      end
    end

    describe 'with invalid params' do
      it 'assigns the model as @model' do
        # Trigger the behavior that occurs when invalid params are submitted
        model.class.any_instance.stub(:save).and_return(false)
        put :update,
            request_params(
              model,
              id: model.to_param,
              assigned_variable => updated_invalid_attributes),
            valid_session
        assigns(assigned_variable).should eq(model)
      end

      it 'returns :unprocessable_entity code' do
        # Trigger the behavior that occurs when invalid params are submitted
        model.class.any_instance.stub(:save).and_return(false)
        put :update,
            request_params(
              model,
              id: model.to_param,
              assigned_variable => updated_invalid_attributes),
            valid_session
        expect(response.response_code).to eq(code(:unprocessable_entity))
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested model' do
      # force the let() execution outside of expect block
      model
      expect do
        delete :destroy,
               request_params(
                model,
                id: model.to_param),
               valid_session
      end.to change(model.class, :count).by(-1)
    end

    it 'returns :no_content code' do
      delete :destroy, request_params(model, id: model.to_param), valid_session
      expect(response.response_code).to eq(code(:no_content))
    end
  end

private

  def code(code)
    Rack::Utils::SYMBOL_TO_STATUS_CODE[code]
  end

  def need_url_params?
    !((defined?(url_params)).nil?)
  end

  def request_params(model, hash = {})
    hash[:format] = :json
    return hash unless need_url_params?

    if model
      populate_based_on_model(model, hash)
    else
      populate_based_on_factory(hash)
    end
  end

  def populate_based_on_model(model, hash = {})
    url_params.each do |param, accessor|
      hash[param] = eval("model.#{accessor}")
    end
    hash
  end

  def populate_based_on_factory(hash = {})
    url_params_factory.each do |param, factory|
      hash[param] = FactoryGirl.create(factory)
    end
    hash
  end
end
