describe "coursesCtrl", ->
  $scope = {}
  $controller = {}
  coursesController = {}
  fakeResults = {}
  factoryMock = {}


  beforeEach ->
    fakeResults = [
      { name: "Course1", user_id: "1"},
      { name: "Course2", user_id: "1"}
    ]

    factoryMock = {
      init: () -> null
      all: () -> fakeResults,
      saveNew: (name) -> {name: "New course", user_id: "1"},
      update: (course, name, callback) -> 
        callback()
        {name: "Physics 8A", user_id: "1"}
      ,
      remove: (course) -> null
    }

  beforeEach ->  
    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'saveNew').and.callThrough()
    spyOn(factoryMock, 'update').and.callThrough()
    spyOn(factoryMock, 'remove')
    spyOn(factoryMock, 'init')

    module "coursesApp", ($provide) ->
      $provide.value 'Course', factoryMock
      return

    inject (_$controller_) ->
      $controller = _$controller_

    coursesController = $controller 'coursesCtrl', {$scope: $scope}

  it "should call Courses.init() and Courses.all() when instantiated", ->
    expect(factoryMock.init).toHaveBeenCalled()
    expect(factoryMock.all).toHaveBeenCalled()
  
  it "initializes needed variables", ->
    expect($scope.courses).toBeDefined()
    expect($scope.courseName).toBeDefined()
    expect($scope.courses).toEqual fakeResults
    expect($scope.hideUpdateButton).toBe true
    expect($scope.hideAddButton).toBe false
    expect($scope.disableEditingAndDeletion).toBe false
    
    
  it "has method remove(course) that is routed to the model and deletes the course from $scope.courses", ->
    expect($scope.remove).toBeDefined()
    id = 0
    courseToRemove = fakeResults[id] 
    $scope.remove(courseToRemove)
    expect(factoryMock.remove).toHaveBeenCalledWith(courseToRemove)
    newResults = [{ name: "Course2", user_id: "1"}]
    expect($scope.courses).toEqual newResults

  it "has method saveNew() that is routed to the model and appends the new course to $scope.courses", ->
    expect($scope.saveNew).toBeDefined()
    $scope.courseName = "New Course"
    $scope.form = {courseName : {$valid : true }}
    $scope.saveNew()
    expect(factoryMock.saveNew).toHaveBeenCalledWith("New Course")
    newResults = [
      { name: "Course1", user_id: "1"},
      { name: "Course2", user_id: "1"},
      { name: "New course", user_id: "1"}
    ]
    expect($scope.courses).toEqual newResults
    expect($scope.courseName).toEqual ""

  it "has method update(course, params) that is routed to the model and updates this course in $scope.courses", ->
    expect($scope.update).toBeDefined()
    id = 0
    name = "Physics 8A"
    courseToUpdate = fakeResults[id] 
    $scope.update(courseToUpdate, name)
    expect(factoryMock.update).toHaveBeenCalledWith(courseToUpdate, name, jasmine.any(Function))
    newResults = [
      { name: "Physics 8A", user_id: "1"},
      { name: "Course2", user_id: "1"}
    ]
    expect($scope.courses).toEqual newResults

  it "has method select(course) that makes the selected course active", ->
    course = { name: "Physics 8A", user_id: "1"}
    expect($scope.select).toBeDefined()
    $scope.select(course)
    pending "Backend for selecting a course is not implemented"

  it "has editForm method that hides 'Add' button, shows 'Update' button and disables other buttons", ->
    $scope.editForm(fakeResults[0])
    expect($scope.hideUpdateButton).toBe false
    expect($scope.hideAddButton).toBe true
    expect($scope.disableEditingAndDeletion).toBe true

  it "has addForm method that shows 'Add' button, hides 'Update' button and enables other buttons", ->
    $scope.addForm()
    expect($scope.hideUpdateButton).toBe true
    expect($scope.hideAddButton).toBe false
    expect($scope.disableEditingAndDeletion).toBe false
