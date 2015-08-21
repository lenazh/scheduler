describe 'AppointmentFormController', ->
  form = {}
  resource = {}
  Navbar = {}
  $scope = {}
  course = {}

  beforeEach ->
    resource = {
      all: -> null
      remove: (resource) -> null
      saveNew: (params) -> null
      update: (resource, params) -> null
      init: -> null
    }

    course = { id: 3, title: 'Bear disarming 42.B'}

    Navbar = {
      navigate: (path) -> null
      items: -> []
      select: (item) -> null
      deselect: (item) -> null
      course: -> course
      title: -> course['title']
      courseId: -> course['id']
      setCourse: (course) -> null
      resetCourse: -> null    
    }

    spyOn(resource, 'all')
    spyOn(resource, 'remove')
    spyOn(resource, 'saveNew')
    spyOn(resource, 'update')

    spyOn(Navbar, 'navigate')
    spyOn(Navbar, 'items')
    spyOn(Navbar, 'select')
    spyOn(Navbar, 'deselect')
    spyOn(Navbar, 'course')
    spyOn(Navbar, 'title')
    spyOn(Navbar, 'courseId')
    spyOn(Navbar, 'setCourse')
    spyOn(Navbar, 'resetCourse')

    form = new schedulerApp.AppointmentFormController($scope, Navbar, resource)

  describe 'constructor', ->
    it 'calls Navbar.course()', ->
      expect(Navbar.course).toHaveBeenCalled()

  describe 'remove(course)', ->
    describe 'when the course is displayed on Navbar', ->
      it 'calls Navbar.resetCourse()', ->
        spyOn(form, '_isDisplayedOnNavbar').and.returnValue true
        form.remove(course)
        expect(Navbar.resetCourse).toHaveBeenCalled()

    describe 'when the course is not displayed on Navbar', ->
      it 'does not call Navbar.resetCourse', ->
        spyOn(form, '_isDisplayedOnNavbar').and.returnValue false
        form.remove(course)
        expect(Navbar.resetCourse).not.toHaveBeenCalled()

  describe 'update()', ->
    beforeEach ->
      spyOn(form, '_updateNavbarTitle')

    describe 'when the course is displayed on Navbar', ->
      it 'calls @_updateNavbarTitle', ->
        spyOn(form, '_isDisplayedOnNavbar').and.returnValue true
        form.fields.name = 'Ololology'
        form.resourceToUpdate = course
        form.update()
        expect(form._updateNavbarTitle).toHaveBeenCalledWith course, 'Ololology'

    describe 'when the course is not displayed on Navbar', ->
      it 'does not call @_updateNavbarTitle', ->
        spyOn(form, '_isDisplayedOnNavbar').and.returnValue false
        form.update()
        expect(form._updateNavbarTitle).not.toHaveBeenCalled()

  describe 'select(course)', ->
    it 'calls @_updateNavbarTitle', ->
      spyOn(form, '_updateNavbarTitle')
      form.select(course)
      expect(form._updateNavbarTitle).toHaveBeenCalledWith course,
        course['name']

  describe 'navigate(path)', ->
    it 'calls Navbar.navigate', ->
      path = 'to the moon'
      form.navigate(path)
      expect(Navbar.navigate).toHaveBeenCalledWith path

  describe 'selectAndNavigate(course, path)', ->
    it 'calls @select and @navigate', ->
      path = 'www.example.com'
      spyOn(form, 'select')
      spyOn(form, 'navigate')
      form.selectAndNavigate(course, path)
      expect(form.select).toHaveBeenCalledWith course
      expect(form.navigate).toHaveBeenCalledWith path
