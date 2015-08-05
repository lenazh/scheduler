class AppointmentFormController extends schedulerApp.FormController

  # "private" methods and fields

  _$scope: {}
  _navbar: {}
  _navbarCourse: {
    'id': 0,
    'title': '(pending...)',
    'teaching': false,
    'owner': false
  }

  _isDisplayedOnNavbar: (course) ->
    course_id = @_navbar.courseId()
    return false unless course_id
    course_id.toString() == course['id'].toString()

  _updateNavbarTitle: (course, title) ->
    @_navbar.setCourse {
      'id': course['id']
      'title': title
      'teaching': course['is_teaching']
      'owner': course['is_owned']
    }

  # public methods

  constructor: ($scope, Navbar, Resource) ->
    Resource.init()
    super Resource, ['name']
    @_$scope = $scope
    @_navbar = Navbar
    @_navbarCourse = @_navbar.course()

  remove: (course) ->
    super
    @_navbar.resetCourse() if @_isDisplayedOnNavbar(course)

  update: ->
    return unless @form_is_valid
    course = @resourceToUpdate
    if @_isDisplayedOnNavbar(course)
      @_updateNavbarTitle course, @fields.name
    super

  select: (course) ->
    @_updateNavbarTitle course, course['name']

schedulerApp.AppointmentFormController = AppointmentFormController