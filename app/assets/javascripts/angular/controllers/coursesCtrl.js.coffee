@schedulerModule.controller 'coursesCtrl', ['$scope', 'Course', 'Navbar', ($scope, Course, Navbar) ->

  @courses = Course.all()
  @courseName = ""

  @hideAddButton = false
  @hideUpdateButton = true
  @disableEditingAndDeletion = false
  navbarCourse = Navbar.course()


  name_is_valid = () ->
    $scope.form.courseName.$valid

  isDisplayedOnNavbar = (course) ->
    navbarCourse['id'] == course['id'].toString()

  @remove = (course) -> 
    Course.remove course
    Navbar.resetCourse() if isDisplayedOnNavbar(course)

  @saveNew = () ->
    return unless name_is_valid
    name = @courseName
    Course.saveNew(@courseName)
    @courseName = ""

  @update = () ->
    return unless name_is_valid
    course = @courseToUpdate
    name = @courseName
    Course.update course, name
    @addForm()
    Navbar.setCourse(course['id'], name) if isDisplayedOnNavbar(course)


  @editForm = (course) ->
    @hideAddButton = true
    @hideUpdateButton = false
    @disableEditingAndDeletion = true
    @courseToUpdate = course
    @courseName = course.name



  @addForm = () ->
    @hideAddButton = false
    @hideUpdateButton = true
    @disableEditingAndDeletion = false
    @courseName = ""



  @select = (course) -> 
    Navbar.setCourse course['id'], course['name']


# The controller will not work w/o this 
# return statement as the coffescript will
# try to return the last defined method

  return
]