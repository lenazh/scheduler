describe "EmploymentFormController", ->
  $scope = {}
  $cookies = {}
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
      all: -> fakeResults,
      saveNew: (params) -> fakeNewResult,
      update: (gsi, params) -> fakeUpdateResult,
      remove: (gsi) -> null
    }

    $cookies = {
      values: {
        'course_id': course_id
        'owner': 'true'
      }

      get: (key) ->
        @values[key]
    }
    $scope = {}

  beforeEach ->
    spyOn(gsiMock, 'all').and.callThrough()
    spyOn(gsiMock, 'saveNew').and.callThrough()
    spyOn(gsiMock, 'update').and.callThrough()
    spyOn(gsiMock, 'remove')
    spyOn(gsiMock, 'init')

    controller = new schedulerApp.EmploymentFormController(
      $scope, $cookies, gsiMock)

  it "calls Gsi.init(...) while initializing with the correct course_id", ->
    expect(gsiMock.init).toHaveBeenCalledWith($cookies.values['course_id'])

  it "has 'email' field", ->
    expect(controller.fields.email).toBeDefined()

  it "has 'hours_per_week' field", ->
    expect(controller.fields.hours_per_week).toBeDefined()

  it 'has @all defined and set to all existing record', ->
    expect(controller.all).toEqual fakeResults
