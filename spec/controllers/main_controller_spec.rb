require 'spec_helper'

describe MainController do

  @routes = ['index', 'courses', 'gsi', 'preferences']

  @routes.each do |route|
    describe "GET /#{route}" do
      it "returns http success" do
        get route
        response.should be_success, "Expected GET /#{route} to return 200, got #{response.response_code} instead"
      end
    end
  end

  describe "GET index" do
    it "makes path variables available to JS"
  end

end
