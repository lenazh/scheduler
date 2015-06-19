describe "navbarFactory", ->

  Navbar = {}
  items = {}
  locationMock = { path: () -> '/gsi' }


# initialize the dependencies and get the objects
  beforeEach module('schedulerApp'), ($provide) ->
    $provide.value '$location', locationMock
    return

  beforeEach ->
    spyOn(locationMock, 'path').and.callThrough()

  beforeEach ->
    inject (_Navbar_) ->
      Navbar = _Navbar_
    items = Navbar.items()

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

