describe "navbarCtrl", ->
  $scope = {}
  $controller = {}
  navbar = {}

  fakeItems = [
    {
      title: "Menu Item 1",
      active: '',
      href: "#item1"
    },
    {
      title: "Menu Item 2",
      active: '',
      href: "#item2"
    }
    {
      title: "Menu Item 3",
      active: '',
      href: "#item3"
    }
  ]

  factoryMock = {
    items: () -> fakeItems,
    select: (item) -> null,
    deselect: (item) -> null
  }

  beforeEach ->  
    spyOn(factoryMock, 'items').and.callThrough()
    spyOn(factoryMock, 'select').and.callThrough()
    spyOn(factoryMock, 'deselect').and.callThrough()


  beforeEach ->
    module "schedulerApp", ($provide) ->
      $provide.value 'Navbar', factoryMock
      return
    inject (_$controller_) ->
      $controller = _$controller_
    navbar = $controller 'navbarCtrl', {$scope: $scope}

  it "should initialize a list of menu items from Navbar factory", ->
    expect(navbar.items).toBeDefined()
    expect(factoryMock.items).toHaveBeenCalled()
    expect(navbar.items.length).toBeGreaterThan 0
    expect(navbar.items).toEqual fakeItems

  it "should have a title", ->
    expect(navbar.title).toBeDefined()

  it "should have a select method that routes to Navbar factory", ->
    expect(navbar.select).toBeDefined()
    navbar.select()
    expect(factoryMock.select).toHaveBeenCalled()