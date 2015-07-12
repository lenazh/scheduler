require "spec_helper"

describe SectionsController do
  describe "routing" do

    it "routes to #index" do
      get("/api/courses/1/sections").should route_to("sections#index", 
        :format => :json, course_id: "1")
    end

    it "routes to #show" do
      get("/api/courses/1/sections/1").should route_to("sections#show", 
        :format => :json, :id => "1", course_id: "1")
    end

    it "routes to #create" do
      post("/api/courses/1/sections").should route_to("sections#create", 
        :format => :json, course_id: "1")
    end

    it "routes to #update" do
      put("/api/courses/1/sections/1").should route_to("sections#update", 
        :format => :json, :id => "1", course_id: "1")
    end

    it "routes to #destroy" do
      delete("/api/courses/1/sections/1").should route_to("sections#destroy", 
        :format => :json, :id => "1", course_id: "1")
    end

  end
end
