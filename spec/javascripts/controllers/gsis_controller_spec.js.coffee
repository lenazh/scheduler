describe "gsiCtrl", ->
  $scope = {}
  $controller = {}
  $routeParams = {}
  controller = {}
  fakeResults = {}
  fakeUpdateResult = {}
  fakeNewResult = {}
  gsiMock = {}
  course_id = 12536

  beforeEach ->
    fakeResults = [
      {
        'id': 1,
        'name': 'Darth Vader',
        'email': 'vader@deathstar.mil',
        'hours_per_week': 20
      },
      {
        'id': 2,
        'name': 'GlaDOS',
        'email': 'root@aperture-science.com',
        'hours_per_week': 168
      }
    ]

    fakeNewResult = {
      'id': 3,
      'name': 'Slurpy',
      'email': 'meh@gmail.com',
      'hours_per_week': 10
    }

    fakeUpdateResult = {
      'id': 2,
      'name': 'GlaDOS',
      'email': 'root@aperture-science.com',
      'hours_per_week': 84
    }

    gsiMock = {
      init: (course_id) -> null
      all: () -> fakeResults,
      saveNew: (params) -> fakeNewResult,
      update: (gsi, params) -> fakeUpdateResult,
      remove: (gsi) -> null
    }

    $routeParams = { 'course_id': course_id }

  beforeEach ->  
    spyOn(gsiMock, 'all').and.callThrough()
    spyOn(gsiMock, 'saveNew').and.callThrough()
    spyOn(gsiMock, 'update').and.callThrough()
    spyOn(gsiMock, 'remove')
    spyOn(gsiMock, 'init')


    module "schedulerApp", ($provide) ->
      $provide.value 'Gsi', gsiMock
      $provide.value '$routeParams', $routeParams
      return

    inject (_$controller_) ->
      $controller = _$controller_

    controller = $controller 'gsiCtrl', {$scope: $scope}

  it "calls Gsi.init(...) while initializing with the correct course_id", ->
    expect(gsiMock.init).toHaveBeenCalledWith($routeParams['course_id'])

  it "calls Gsi.all() while initializing", ->
    expect(gsiMock.all).toHaveBeenCalled()
  
  it "initializes variables", ->
    expect(controller.gsis).toBeDefined()
    expect(controller.email).toBeDefined()
    expect(controller.hoursPerWeek).toBeDefined()
    expect(controller.gsis).toEqual fakeResults
    expect(controller.hideUpdateButton).toBe true
    expect(controller.hideAddButton).toBe false
    expect(controller.disableEditingAndDeletion).toBe false

  describe "has method remove(gsi) that", ->
    it "is defined", ->
      expect(controller.remove).toBeDefined()

    it "is routed to the model", ->
      id = 0
      gsiToRemove = fakeResults[id] 
      controller.remove(gsiToRemove)
      expect(gsiMock.remove).toHaveBeenCalledWith(gsiToRemove)

  it 'has fields @email and @hoursPerWeek defined', ->
    expect(controller.email).toBeDefined()
    expect(controller.hoursPerWeek).toBeDefined()

  it "has method saveNew() that is routed to the model", ->
    expect(controller.saveNew).toBeDefined()
    controller.email = fakeNewResult['email']
    controller.hoursPerWeek = fakeNewResult['hours_per_week']
    params = {
      'email': fakeNewResult['email'],
      'hours_per_week': fakeNewResult['hours_per_week']
    }
    $scope.form = { 'email': { $valid : true } }
    $scope.form = { 'hours_per_week': { $valid : true } }
    controller.saveNew()
    expect(gsiMock.saveNew).toHaveBeenCalledWith(params)

  describe "has method update() that ", ->
    it "is defined", ->
      expect(controller.update).toBeDefined()

    it "is routed to the model", ->
      id = 0
      name = "Physics 8A"
      gsiToUpdate = angular.copy fakeResults[id]
      controller.gsiToUpdate = gsiToUpdate
      controller.email = fakeUpdateResult['email']
      controller.hoursPerWeek = fakeUpdateResult['hours_per_week']
      $scope.form = { 'email': { $valid : true } }
      $scope.form = { 'hours_per_week': { $valid : true } }
      params = {
        'email': fakeUpdateResult['email'],
        'hours_per_week': fakeUpdateResult['hours_per_week']
      }
      controller.update()
      expect(gsiMock.update).toHaveBeenCalledWith(gsiToUpdate, params)


  it "has editForm method that hides 'Add' button, shows 'Update' button and disables other buttons", ->
    controller.editForm(fakeResults[0])
    expect(controller.hideUpdateButton).toBe false
    expect(controller.hideAddButton).toBe true
    expect(controller.disableEditingAndDeletion).toBe true
    expect(controller.gsiToUpdate).toEqual fakeResults[0]
    expect(controller.email).toEqual fakeResults[0]['email']
    expect(controller.hoursPerWeek).toEqual fakeResults[0]['hours_per_week']

  it "has addForm method that shows 'Add' button, hides 'Update' button and enables other buttons", ->
    controller.addForm()
    expect(controller.hideUpdateButton).toBe true
    expect(controller.hideAddButton).toBe false
    expect(controller.disableEditingAndDeletion).toBe false
    expect(controller.email).toEqual ''
    expect(controller.hoursPerWeek).toEqual ''
