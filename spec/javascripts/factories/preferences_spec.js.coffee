describe "Preferences", ->
# define the local variables
  Resource = {}
  $httpBackend = {}
  course_id = 1
  section_id = 19
  hostPath = "http://192.168.56.101:3000"
  coursesPath = "/api/courses"
  getPath =
    "#{coursesPath}/#{course_id}/preferences/get"
  setPath = "#{coursesPath}/#{course_id}/preferences/set"

  gon = {}
  getResponse = {}
  setResponse = {}
  successCallback = {}
  oldPreference = 0.45
  newPreference = 0.1

  beforeEach ->
    getResponse = {
      'id': 3,
      'user_id': 6,
      'section_id': section_id,
      'preference': oldPreference
    }

    setResponse = {
      'id': 3,
      'user_id': 6,
      'section_id': section_id,
      'preference': newPreference
    }

    successCallback = jasmine.createSpy('successCallback')

    gon = {}
    gon.courses_api_path = coursesPath
    window.gon = gon

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      return

    inject (_Preference_) ->
      Resource = _Preference_
      Resource.init(course_id)

  describe 'get(section)', ->
    beforeEach ->
      $httpBackend.expectGET(getPath).respond(200, getResponse)
      preference = Resource.get(section_id, successCallback)
      $httpBackend.flush()

    it 'loads the correct route', ->
      expect(true).toBe(true) # the expectation is in beforeEach block

    it 'calls successCallback() with the preference value', ->
      expect(successCallback).toHaveBeenCalledWith(oldPreference)

  describe 'set(section, preference)', ->
    it 'loads the correct route', ->
      $httpBackend.expectPUT(setPath).respond(201, setResponse)
      preference = Resource.set(section_id, successCallback)
      $httpBackend.flush()
      expect(true).toBe(true) # the expectation is in .flush()
