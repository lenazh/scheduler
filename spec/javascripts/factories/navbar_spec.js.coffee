describe "navbarFactory", ->

  Navbar = {}
  items = {}

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject (_Navbar_) ->
      Navbar = _Navbar_
    items = Navbar.items

  it "has items() method that returns an item list", ->
    expect(Navbar.items()).toBeDefined()
    myItems = Navbar.items()
    expect(myItems.length).toBeGreaterThan 0

  it "has select(item) method", ->
    expect(Navbar.select()).toBeDefined()

  it "has deselect(item) method", ->
    expect(Navbar.deselect()).toBeDefined()

