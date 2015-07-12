describe "coursesCtrl", ->
  $scope = {}
  $controller = {}
  crs = {}
  fakeResults = {}
  courseMock = {}
  navbarMock = {}


  beforeEach ->
    fakeResults = [
      { name: "Course1", user_id: "1", id: 1},
      { name: "Course2", user_id: "1", id: 2}
    ]

    courseMock = {
      init: () -> null
      all: () -> fakeResults,
      saveNew: (name) -> {name: "New course", user_id: "1", id: 3},
      update: (course, name) -> {name: "Physics 8A", user_id: "1", id: 1},
      remove: (course) -> null
    }

    navbarMock = {
      resetCourse: () -> null
      setCourse: (id, name) -> null
      title: () -> {'title': 'Course1', 'id': 2}
    }

  beforeEach ->  
    spyOn(courseMock, 'all').and.callThrough()
    spyOn(courseMock, 'saveNew').and.callThrough()
    spyOn(courseMock, 'update').and.callThrough()
    spyOn(courseMock, 'remove')
    spyOn(courseMock, 'init')
    spyOn(navbarMock, 'setCourse')
    spyOn(navbarMock, 'resetCourse')

    module "schedulerApp", ($provide) ->
      $provide.value 'Course', courseMock
      $provide.value 'Navbar', navbarMock
      return

    inject (_$controller_) ->
      $controller = _$controller_

    crs = $controller 'coursesCtrl', {$scope: $scope}

  it "should call Courses.all() when instantiated", ->
    expect(courseMock.all).toHaveBeenCalled()
  
  it "initializes needed variables", ->
    expect(crs.courses).toBeDefined()
    expect(crs.courseName).toBeDefined()
    expect(crs.courses).toEqual fakeResults
    expect(crs.hideUpdateButton).toBe true
    expect(crs.hideAddButton).toBe false
    expect(crs.disableEditingAndDeletion).toBe false
    
    
  describe "has method remove(course) that", ->
    it "is defined", ->
      expect(crs.remove).toBeDefined()

    it "is routed to the model", ->
      id = 0
      courseToRemove = fakeResults[id] 
      crs.remove(courseToRemove)
      expect(courseMock.remove).toHaveBeenCalledWith(courseToRemove)

    it "resets the Navbar title when the current course is being deleted", ->
      id = 1
      courseToRemove = fakeResults[id] 
      crs.remove(courseToRemove)
      expect(navbarMock.resetCourse).toHaveBeenCalled()

  it "has method saveNew() that is routed to the model", ->
    expect(crs.saveNew).toBeDefined()
    crs.courseName = "New Course"
    $scope.form = {courseName : {$valid : true }}
    crs.saveNew()
    expect(courseMock.saveNew).toHaveBeenCalledWith("New Course")


  describe "has method update(course, params) that ", ->
    it "is defined", ->
      expect(crs.update).toBeDefined()

    it "is routed to the model", ->
      id = 0
      name = "Physics 8A"
      crs.courseToUpdate = fakeResults[id] 
      crs.courseName = name
      crs.update()
      expect(courseMock.update).toHaveBeenCalledWith(fakeResults[id], name)

    it "updates the Navbar title when the current course is updates", ->
      id = 1
      name = "Physics 8A"
      crs.courseToUpdate = fakeResults[id] 
      crs.courseName = name
      crs.update()
      expect(navbarMock.setCourse).toHaveBeenCalledWith(fakeResults[id]['id'], name)


  it "has method select(course) that makes the selected course active", ->
    course = { name: "Physics 8A", user_id: "1", id: 2}
    expect(crs.select).toBeDefined()
    crs.select(course)
    expect(navbarMock.setCourse).toHaveBeenCalledWith(2, "Physics 8A")

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
