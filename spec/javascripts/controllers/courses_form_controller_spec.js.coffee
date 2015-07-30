describe "coursesCtrl", ->
  $scope = {}
  controller = {}
  fakeResults = {}
  courseMock = {}
  navbarMock = {}


  beforeEach ->
    fakeResults = [
      { name: "Course1", user_id: "1", id: '1'},
      { name: "Course2", user_id: "1", id: '2'}
    ]

    courseMock = {
      init: () -> null
      all: () -> fakeResults,
      saveNew: (params) -> {name: "New course", user_id: "1", id: '3'},
      update: (course, params) -> {name: "Physics 8A", user_id: "1", id: '1'},
      remove: (course) -> null
    }

    navbarMock = {
      resetCourse: () -> null
      setCourse: (id, name) -> null
      course: () -> {'title': 'Course1', 'id': '2'}
    }

  beforeEach ->  
    spyOn(courseMock, 'all').and.callThrough()
    spyOn(courseMock, 'saveNew').and.callThrough()
    spyOn(courseMock, 'update').and.callThrough()
    spyOn(courseMock, 'remove')
    spyOn(courseMock, 'init')
    spyOn(navbarMock, 'setCourse')
    spyOn(navbarMock, 'resetCourse')
    spyOn(navbarMock, 'course').and.callThrough()

    $scope = {}

    controller = new schedulerApp.CourseFormController(
      $scope, navbarMock, courseMock)

  it "calls Navbar.course() while initializing", ->
    expect(navbarMock.course).toHaveBeenCalled()
  
  it "has 'name' field", ->
    expect(controller.fields.name).toBeDefined()

  describe "has method remove(course) that", ->
    it "resets the Navbar title when the current course is being deleted", ->
      id = 1
      courseToRemove = fakeResults[id] 
      controller.remove(courseToRemove)
      expect(navbarMock.resetCourse).toHaveBeenCalled()

  describe "has method update() that ", ->
    it "updates the Navbar title when the current course is updates", ->
      id = 1
      name = "Physics 8A"
      controller.resourceToUpdate = fakeResults[id] 
      controller.fields.name = name
      controller.update()
      expect(navbarMock.setCourse).toHaveBeenCalledWith(
        fakeResults[id]['id'], name)

  it "has method select(course) that makes the selected course active", ->
    course = { name: "Physics 8A", user_id: "1", id: 2}
    expect(controller.select).toBeDefined()
    controller.select(course)
    expect(navbarMock.setCourse).toHaveBeenCalledWith(2, "Physics 8A")
