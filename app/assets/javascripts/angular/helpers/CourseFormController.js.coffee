class CourseFormController extends schedulerApp.FormController
  $scope = {}
  Navbar = {}
  navbarCourse = { 'id': 0, 'title': '(pending...)' }

  isDisplayedOnNavbar = (course) ->
    navbarCourse['id'] == course['id'].toString()

  constructor: (_$scope_, _Navbar_, Course) ->
    Course.init()
    super Course, ['name']
    $scope = _$scope_
    Navbar = _Navbar_
    navbarCourse = Navbar.course()

  form_is_valid: ->
    $scope.form.name.$valid

  remove: (course) ->
    super
    Navbar.resetCourse() if isDisplayedOnNavbar(course)

  update: ->
    return unless @form_is_valid
    course = @resourceToUpdate
    Navbar.setCourse(course['id'], @fields.name) if isDisplayedOnNavbar(course)
    super

  select: (course) ->
    Navbar.setCourse course['id'], course['name']

schedulerApp.CourseFormController = CourseFormController