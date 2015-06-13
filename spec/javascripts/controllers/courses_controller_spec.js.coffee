describe "coursesCtrl", ->
  fakeResults = [
    { name: "Course1", user_id: "1"},
    { name: "Course2", user_id: "1"}
  ]

  factoryMock = {
    all: () -> fakeResults,
    save: () -> null,
    update: () -> null,
    remove: () -> null
  }

  $scope = {}
  coursesController = {}
  id = 123
  name = "Physics 8A"

  beforeEach ->  
    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'save')
    spyOn(factoryMock, 'update')
    spyOn(factoryMock, 'remove')

    module "coursesApp", ($provide) ->
      $provide.value 'Course', factoryMock
      return

    inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()
      coursesController = $controller 'coursesCtrl', {$scope: $scope}

  it "should query all() courses owned by the user", ->
    expect(factoryMock.all).toHaveBeenCalled()
  
  it "should assign the returned courses to 'courses' variable", ->
    expect($scope.courses).toBeDefined()
    expect($scope.courses).toEqual fakeResults
    
  it "has method remove(id) that is routed to the model", ->
    expect($scope.remove).toBeDefined()
    $scope.remove(id)
    expect(factoryMock.remove).toHaveBeenCalledWith(id)

  it "has method save(params) that is routed to the model", ->
    expect($scope.save).toBeDefined()
    $scope.save(name)
    expect(factoryMock.save).toHaveBeenCalledWith(name)

  it "has method update(id, params) that is routed to the model", ->
    expect($scope.update).toBeDefined()
    $scope.update(id, name)
    expect(factoryMock.update).toHaveBeenCalledWith(id, name)

  it "has method select(id) that makes the selected course active", ->
    expect($scope.select).toBeDefined()
    $scope.select(id)
    pending "Backend for selecting a course is not implemented"
