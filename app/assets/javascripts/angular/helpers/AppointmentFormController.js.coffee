class AppointmentFormController extends schedulerApp.FormController

  # "private" methods and fields

  _$scope: {}
  _navbar: {}
  _navbarCourse: { 'id': 0, 'title': '(pending...)' }

  _isDisplayedOnNavbar: (course) ->
    @_navbarCourse['id'] == course['id'].toString()

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
      @_navbar.setCourse(course['id'], @fields.name)
    super

  select: (course) ->
    @_navbar.setCourse course['id'], course['name']

schedulerApp.AppointmentFormController = AppointmentFormController