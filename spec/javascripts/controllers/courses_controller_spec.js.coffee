describe "coursesCtrl", ->
  fakeResults = [
    { name: "Course1", user_id: "1"},
    { name: "Course2", user_id: "1"}
  ]

  factoryMock = {query: () -> fakeResults}
  $scope = {}

  beforeEach ->  
    spyOn(factoryMock, 'query').and.callThrough()
    
    module "coursesApp", ($provide) ->
      $provide.value 'Course', factoryMock
      return

    inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()
      $controller 'coursesCtrl', {$scope: $scope}

  it "should query all courses owned by the user", ->
    expect(factoryMock.query).toHaveBeenCalled()
  
  it "should assign the courses to 'courses' variable", ->
    expect($scope.courses).toBeDefined()
    expect($scope.courses).toEqual fakeResults
    

