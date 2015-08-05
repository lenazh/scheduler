describe "CourseFormController", ->
  $scope = {}
  controller = {}
  fakeResults = {}
  courseMock = {}
  navbarMock = {}


  beforeEach ->
    fakeResults = [
      {
        id: '1',
        name: "Course1",
        user_id: "1",
        'is_teaching': false,
        'is_owned': true
      },
      {
        id: '2',
        name: "Course2",
        user_id: "1",
        'is_teaching': false,
        'is_owned': true
      }
    ]

    courseMock = {
      init: -> null
      all: -> fakeResults,
      saveNew: (params) -> {name: "New course", user_id: "1", id: '3'},
      update: (course, params) -> {name: "Physics 8A", user_id: "1", id: '1'},
      remove: (course) -> null
    }

    navbarMock = {
      resetCourse: -> null
      setCourse: (id, name) -> null
      course: -> {'title': 'Course1', 'id': '2'}
      title:  -> 'title'
      courseId: -> '2'
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
      expect(navbarMock.setCourse).toHaveBeenCalledWith {
        'id': fakeResults[id]['id']
        'title': name
        'teaching': false
        'owner': true
      }

  it "has method select(course) that makes the selected course active", ->
    fakeTitle = "Physics 8A"
    fakeId = 2
    course = {
      id: fakeId,
      name: fakeTitle,
      user_id: "1",
      'is_teaching': false
      'is_owned': true
    }
    expect(controller.select).toBeDefined()
    controller.select(course)
    expect(navbarMock.setCourse).toHaveBeenCalledWith {
      'id': fakeId
      'title': fakeTitle
      'teaching': false
      'owner': true
    }
