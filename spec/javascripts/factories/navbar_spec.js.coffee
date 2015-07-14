describe "navbarFactory", ->

  Navbar = {}
  items = {}
  fakeId = 123
  fakeTitle = "Fake Course"
  locationMock = {}
  $cookies = {}


# initialize the dependencies and get the objects
  beforeEach ->
    locationMock = { path: () -> '/gsi' }
    spyOn(locationMock, 'path').and.callThrough()

  beforeEach module('schedulerApp'), ($provide) ->
    $provide.value '$location', locationMock
    return

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

  it "has items() method that returns an item list", ->
    expect(Navbar.items).toBeDefined()
    expect(items.length).toBeGreaterThan 0

  it "has select(item) method that sets the selected method active and all the other inactive", ->
    expect(Navbar.select).toBeDefined()
    for itemToSelect in items
      Navbar.select itemToSelect
      for item in items
        if item == itemToSelect
          expect(item.active).toEqual 'active'
        else
          expect(item.active).toEqual ''

  it "has deselect(item) method that is only used internally so far", ->
    expect(Navbar.deselect).toBeDefined()

  it "selects the correct menu item based on the $location.path() when it initializes", ->
    pending "need to stub out $location somehow"
    expect(locationMock.path).toHaveBeenCalled()
    expect(items[2].active).toEqual 'active'

  it "has Navbar.course method that returns the current course", ->
    expect(Navbar.course).toBeDefined()
    course = Navbar.course()
    expect(course['title']).toEqual jasmine.any(String)

  it "has Navbar.setCourse(id, name) that sets the course as the current", ->
    Navbar.setCourse(fakeId, fakeTitle)
    course = Navbar.course()
    expect(course['title']).toEqual("Fake Course")
    expect($cookies.put).toHaveBeenCalledWith('course_id', fakeId)
    expect($cookies.put).toHaveBeenCalledWith('course_title', fakeTitle)

  it "has Navbar.resetCourse() that sets the current course to blank", ->
    Navbar.resetCourse()
    expect($cookies.remove).toHaveBeenCalledWith('course_id')
    expect($cookies.remove).toHaveBeenCalledWith('course_title')
    course = Navbar.course()
    expect(course['title']).toMatch(/select/i)
    expect(course['id']).toEqual null


