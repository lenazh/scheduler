describe "navbarFactory", ->

  Navbar = {}
  items = {}

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
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

