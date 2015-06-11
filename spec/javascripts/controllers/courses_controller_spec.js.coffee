describe "coursesCtrl", ->
  beforeEach module("coursesApp")

  describe "when JSON resource is accessible", ->
    it "should initialize courses to list of all courses owned by the user", inject(($controller) ->
      scope = {}
      ctrl = $controller('coursesCtrl', $scope: scope)
      fail "Just because"
    )
