describe "NavbarCtrl", ->
  $scope = {}
  $controller = {}
  navbar = {}

  fakeItems = [
    {
      title: "Menu Item 1",
      active: '',
      href: () -> "#item1"
    },
    {
      title: "Menu Item 2",
      active: '',
      href: () -> "#item2"
    }
    {
      title: "Menu Item 3",
      active: '',
      href: () -> "#item3"
    }
  ]

  factoryMock = {
    items: () -> fakeItems,
    select: (item) -> null,
    deselect: (item) -> null,
    course: () -> {
      'title': "Selected course",
      'id': 1
    }
  } 

  beforeEach ->  
    spyOn(factoryMock, 'items').and.callThrough()
    spyOn(factoryMock, 'select').and.callThrough()
    spyOn(factoryMock, 'deselect').and.callThrough()
    spyOn(factoryMock, 'course').and.callThrough()


  beforeEach ->
    module "schedulerApp", ($provide) ->
      $provide.value 'Navbar', factoryMock
      return
    inject (_$controller_) ->
      $controller = _$controller_
    navbar = $controller 'NavbarCtrl', {$scope: $scope}

  it "should initialize a list of menu items from Navbar factory", ->
    expect(navbar.items).toBeDefined()
    expect(factoryMock.items).toHaveBeenCalled()
    expect(navbar.items.length).toBeGreaterThan 0
    expect(navbar.items).toEqual fakeItems

  it "should request a title from the factory while initializing", ->
    expect(factoryMock.course).toHaveBeenCalled()

  it "should have a course that it receives from the factory", ->
    expect(navbar.course).toBeDefined()
    expect(navbar.course).toEqual factoryMock.course()

  it "should have a select method that routes to Navbar factory", ->
    expect(navbar.select).toBeDefined()
    navbar.select()
    expect(factoryMock.select).toHaveBeenCalled()
