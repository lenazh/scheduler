class AppointmentFormController extends schedulerApp.FormController
  scope: {}
  Navbar = {}
  navbarCourse = { 'id': 0, 'title': '(pending...)' }

  isDisplayedOnNavbar = (course) ->
    navbarCourse['id'] == course['id'].toString()

  constructor: (_$scope_, _Navbar_, Resource) ->
    Resource.init()
    super Resource, ['name']
    @scope = _$scope_
    Navbar = _Navbar_
    navbarCourse = Navbar.course()

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

schedulerApp.AppointmentFormController = AppointmentFormController