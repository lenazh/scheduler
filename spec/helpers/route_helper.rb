module RouteHelper
  def expect_to_respond_to(routes)
    routes.each do |route|
      get route
      response.should be_success, "Expected GET /#{route} to return 200, got #{response.response_code} instead"
    end
  end
end