describe "gsiCtrl", ->
  $scope = {}
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
    $scope = {}

  beforeEach -> 
    spyOn(gsiMock, 'all').and.callThrough()
    spyOn(gsiMock, 'saveNew').and.callThrough()
    spyOn(gsiMock, 'update').and.callThrough()
    spyOn(gsiMock, 'remove')
    spyOn(gsiMock, 'init')

    controller = new schedulerApp.GsiFormController($scope, $routeParams, gsiMock)

  it "calls Gsi.init(...) while initializing with the correct course_id", ->
    expect(gsiMock.init).toHaveBeenCalledWith($routeParams['course_id'])

  it "calls Gsi.all() while initializing", ->
    expect(gsiMock.all).toHaveBeenCalled()
  
  it 'has @email defined and identical to @fields.email', ->
    expect(controller.email).toBeDefined()
    email = 'sidious@deathstar.mil'
    controller.fields.email = email

  it 'has @hours_per_week defined and identical to @fields.hours_per_week', ->
    expect(controller.hours_per_week).toBeDefined()
    hours_per_week = 36
    controller.fields.hours_per_week = hours_per_week

  it 'has @all defined and set to all existing record', ->
    expect(controller.all).toEqual fakeResults
