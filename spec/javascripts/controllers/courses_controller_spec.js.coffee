describe "coursesCtrl", ->
  fakeResults = [
    { name: "Course1", user_id: "1"},
    { name: "Course2", user_id: "1"}
  ]

  factoryMock = {
    init: () -> null
    all: () -> fakeResults,
    saveNew: () -> null,
    update: () -> null,
    remove: () -> null
  }

  $scope = {}
  coursesController = {}
  course = {user_id: 123, name: "New course"}
  name = "Physics 8A"

  beforeEach ->  
    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'saveNew')
    spyOn(factoryMock, 'update')
    spyOn(factoryMock, 'remove')
    spyOn(factoryMock, 'init')

    module "coursesApp", ($provide) ->
      $provide.value 'Course', factoryMock
      return

    inject ($rootScope, $controller) ->
      $scope = $rootScope.$new()
      coursesController = $controller 'coursesCtrl', {$scope: $scope}

  it "should call Courses.init() and Courses.all() when instantiated", ->
    expect(factoryMock.init).toHaveBeenCalled()
    expect(factoryMock.all).toHaveBeenCalled()
  
  it "should assign the returned courses to 'courses' variable", ->
    expect($scope.courses).toBeDefined()
    expect($scope.courses).toEqual fakeResults
    
  it "has method remove(course) that is routed to the model", ->
    expect($scope.remove).toBeDefined()
    $scope.remove(course)
    expect(factoryMock.remove).toHaveBeenCalledWith(course)

  it "has method saveNew(params) that is routed to the model", ->
    expect($scope.saveNew).toBeDefined()
    $scope.saveNew(name)
    expect(factoryMock.saveNew).toHaveBeenCalledWith(name)

  it "has method update(course, params) that is routed to the model", ->
    expect($scope.update).toBeDefined()
    $scope.update(course, name)
    expect(factoryMock.update).toHaveBeenCalledWith(course, name)

  it "has method select(course) that makes the selected course active", ->
    expect($scope.select).toBeDefined()
    $scope.select(course)
    pending "Backend for selecting a course is not implemented"
