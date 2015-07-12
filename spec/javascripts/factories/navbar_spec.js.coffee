describe "navbarFactory", ->

  Navbar = {}
  items = {}
  fakeId = 123
  fakeTitle = "Fake Course"
  fakeCookies = {}
  locationMock = {}
  $cookies = {}


# initialize the dependencies and get the objects
  beforeEach ->
    fakeCookies = { 'course_id': fakeId, 'course_title': fakeTitle }
    locationMock = { path: () -> '/gsi' }
    spyOn(locationMock, 'path').and.callThrough()

  beforeEach module('schedulerApp'), ($provide) ->
    $provide.value '$location', locationMock
    return

  beforeEach ->
    inject (_$cookies_, _Navbar_) ->
      Navbar = _Navbar_
      $cookies = _$cookies_
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

  it "has Navbar.title method that returns the name of the current course", ->
    expect(Navbar.title).toBeDefined()
    title = Navbar.title()
    expect(title['title']).toEqual jasmine.any(String)

  it "has Navbar.setCourse(id, name) that sets the course as the current", ->
    Navbar.setCourse(fakeId, fakeTitle)
    title = Navbar.title()
    expect(title['title']).toEqual("Fake Course")
    expect($cookies.put).toHaveBeenCalledWith('course_id', fakeId)
    expect($cookies.put).toHaveBeenCalledWith('course_title', fakeTitle)

  it "has Navbar.resetCourse() that sets the current course to blank", ->
    Navbar.resetCourse()
    expect($cookies.remove).toHaveBeenCalledWith('course_id')
    expect($cookies.remove).toHaveBeenCalledWith('course_title')
    title = Navbar.title()
    expect(title['title']).toMatch(/select/i)
    expect(title['id']).toEqual null


