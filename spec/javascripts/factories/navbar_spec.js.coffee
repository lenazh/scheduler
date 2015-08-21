describe "navbarFactory", ->

  Navbar = {}
  items = {}
  fakeId = 123
  fakeTitle = "Fake Course"
  $cookies = {}
  $location = {}


# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')

  beforeEach ->
    inject (_$cookies_, _Navbar_) ->
      Navbar = _Navbar_
      $cookies = _$cookies_
      # when I $provide a mock for $cookie (like $location)
      # the mock does not get called ($location mock does)
      $cookies.put('course_title', 'Derpology')
      $cookies.put('course_id', '1')
    items = Navbar.items()
    spyOn($cookies, 'get').and.callThrough()
    spyOn($cookies, 'put').and.callThrough()
    spyOn($cookies, 'remove').and.callThrough()
    return

  beforeEach ->
    inject (_$location_, _Navbar_) ->
      $location = _$location_
      spyOn($location, 'path').and.callThrough()
      return

  describe 'items', ->
    it "returns the item list", ->
      expect(items.length).toBeGreaterThan 0

  describe 'select(item)', ->
    it "sets the selected method active and all the others inactive", ->
      for itemToSelect in items
        Navbar.select itemToSelect
        for item in items
          if item == itemToSelect
            expect(item.active).toEqual 'active'
          else
            expect(item.active).toEqual ''

  describe 'deselect(item)', ->
    it "is defined (only used internally so far)", ->
      expect(Navbar.deselect).toBeDefined()

  # it "selects the correct menu item based on the $location.path() when it initializes", ->
  #   pending "need to stub out $location somehow"

  describe 'course()', ->
    it "returns the current course", ->
      course = Navbar.course()
      expect(course['title']).toEqual jasmine.any(String)

  describe 'setCourse(course)', ->
    course = {}
    navbarCourse = {}
    expirationDate = ->
        now = new Date()
        expires = new Date now.getFullYear() + 1, now.getMonth(), now.getDate()

    beforeEach ->
      course = {
        'id': fakeId
        'title': fakeTitle
        'teaching': true
        'owner': false
      }
      
      Navbar.setCourse(course)
      navbarCourse = Navbar.course()


    it "sets the course as the current", ->
      expect(navbarCourse['id']).toEqual fakeId
      expect(navbarCourse['title']).toEqual fakeTitle
      expect(navbarCourse['teaching']).toBe true
      expect(navbarCourse['owner']).toBe false

    it 'stores the course data in cookies', ->
      expect($cookies.put).toHaveBeenCalledWith 'course_id',
        fakeId, { expires: expirationDate() }
      expect($cookies.put).toHaveBeenCalledWith 'course_title',
        fakeTitle, { expires: expirationDate() }
      expect($cookies.put).toHaveBeenCalledWith 'course_teaching',
        true, { expires: expirationDate() }
      expect($cookies.put).toHaveBeenCalledWith 'course_owner',
        false, { expires: expirationDate() }

  describe 'resetCourse()', ->
    beforeEach ->
      Navbar.resetCourse()

    it "sets the current course to blank", ->
      course = Navbar.course()
      expect(course['id']).not.toBeDefined()
      expect(course['title']).toMatch(/select/i)
      expect(course['teaching']).toBe false
      expect(course['owner']).toBe false

    it "clears the course cookies", ->
      expect($cookies.remove).toHaveBeenCalledWith('course_id')
      expect($cookies.remove).toHaveBeenCalledWith('course_title')
      expect($cookies.remove).toHaveBeenCalledWith('course_teaching')
      expect($cookies.remove).toHaveBeenCalledWith('course_owner')

  describe 'navigate(path)', ->
    it 'calls $location(path)', ->
      path = "example.com"
      Navbar.navigate path
      expect($location.path).toHaveBeenCalledWith path

