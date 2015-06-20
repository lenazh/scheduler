describe "coursesCtrl", ->
  $scope = {}
  $controller = {}
  crs = {}
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
      update: (course, name) -> {name: "Physics 8A", user_id: "1"},
      remove: (course) -> null
    }

  beforeEach ->  
    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'saveNew').and.callThrough()
    spyOn(factoryMock, 'update').and.callThrough()
    spyOn(factoryMock, 'remove')
    spyOn(factoryMock, 'init')

    module "schedulerApp", ($provide) ->
      $provide.value 'Course', factoryMock
      return

    inject (_$controller_) ->
      $controller = _$controller_

    crs = $controller 'coursesCtrl', {$scope: $scope}

  it "should call Courses.all() when instantiated", ->
    expect(factoryMock.all).toHaveBeenCalled()
  
  it "initializes needed variables", ->
    expect(crs.courses).toBeDefined()
    expect(crs.courseName).toBeDefined()
    expect(crs.courses).toEqual fakeResults
    expect(crs.hideUpdateButton).toBe true
    expect(crs.hideAddButton).toBe false
    expect(crs.disableEditingAndDeletion).toBe false
    
    
  it "has method remove(course) that is routed to the model", ->
    expect(crs.remove).toBeDefined()
    id = 0
    courseToRemove = fakeResults[id] 
    crs.remove(courseToRemove)
    expect(factoryMock.remove).toHaveBeenCalledWith(courseToRemove)

  it "has method saveNew() that is routed to the model", ->
    expect(crs.saveNew).toBeDefined()
    crs.courseName = "New Course"
    $scope.form = {courseName : {$valid : true }}
    crs.saveNew()
    expect(factoryMock.saveNew).toHaveBeenCalledWith("New Course")


  it "has method update(course, params) that is routed to the model", ->
    expect(crs.update).toBeDefined()
    id = 0
    name = "Physics 8A"
    crs.courseToUpdate = fakeResults[id] 
    crs.courseName = name
    crs.update()
    expect(factoryMock.update).toHaveBeenCalledWith(fakeResults[id], name)


  it "has method select(course) that makes the selected course active", ->
    course = { name: "Physics 8A", user_id: "1"}
    expect(crs.select).toBeDefined()
    crs.select(course)
    pending "Backend for selecting a course is not implemented"

  it "has editForm method that hides 'Add' button, shows 'Update' button and disables other buttons", ->
    crs.editForm(fakeResults[0])
    expect(crs.hideUpdateButton).toBe false
    expect(crs.hideAddButton).toBe true
    expect(crs.disableEditingAndDeletion).toBe true
    expect(crs.courseToUpdate).toEqual fakeResults[0]
    expect(crs.courseName).toEqual fakeResults[0]['name']

  it "has addForm method that shows 'Add' button, hides 'Update' button and enables other buttons", ->
    crs.addForm()
    expect(crs.hideUpdateButton).toBe true
    expect(crs.hideAddButton).toBe false
    expect(crs.disableEditingAndDeletion).toBe false
    expect(crs.courseName).toEqual ''
