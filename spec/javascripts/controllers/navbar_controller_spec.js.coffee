describe "navbarCtrl", ->
  $scope = {}
  $controller = {}
  navbar = {}

  beforeEach ->
    module "schedulerApp"
    inject (_$controller_) ->
      $controller = _$controller_
    navbar = $controller 'navbarCtrl', {$scope: $scope}

  it "should initialize a list of menu items", ->
    expect(navbar.items).toBeDefined()
    expect(navbar.items.length).toBeGreaterThan 0

  it "should have a title", ->
    expect(navbar.title).toBeDefined()

  describe "select method", ->
    menuItems = 
      [
        {
          title: "Option 1",
          active: "",
          href: "#option1"
        },
        {
          title: "Option 2",
          active: "",
          href: "#option2"
        },
        {
          title: "Option 3",
          active: "",
          href: "#option3"
        }
      ]

    beforeEach ->
      navbar.items = menuItems
      navbar.selected = null

    it "should be defined", ->
      expect(navbar.select).toBeDefined()

    it "should set class of the selected element to 'active' and all others to ''", ->
      navbar.select menuItems[1]
      expect(navbar.items[0].active).toEqual ''
      expect(navbar.items[1].active).toEqual 'active'
      expect(navbar.items[2].active).toEqual ''
      navbar.select menuItems[0]
      expect(navbar.items[0].active).toEqual 'active'
      expect(navbar.items[1].active).toEqual ''
      expect(navbar.items[2].active).toEqual ''
      navbar.select menuItems[2]
      expect(navbar.items[0].active).toEqual ''
      expect(navbar.items[1].active).toEqual ''
      expect(navbar.items[2].active).toEqual 'active'