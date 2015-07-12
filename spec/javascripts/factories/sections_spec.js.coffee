describe "Sections", ->
# define the local variables
  Resource = {}
  $httpBackend = {}
  course_id = 1
  coursesPath = "/api/courses"
  resourcePath = "#{coursesPath}/#{course_id}/sections"
  hostPath = "http://192.168.56.101:3000"
  resourceUrl = "#{hostPath}#{resourcePath}"

# stub out gon
  window.gon = {}
  gon.courses_api_path = coursesPath

# canned responses defined here
  allFakeResources = {}
  createdResource = {}
  successCallback = {}
  errorCallback = {}
# Makes the call that returns all existing courses
  GetAllResources = ->
    $httpBackend.expectGET(resourcePath).respond(200, allFakeResources)
    allResources = Resource.all(successCallback)
    $httpBackend.flush()
    expect(successCallback).toHaveBeenCalled()
    allResources

  beforeEach ->
    allFakeResources = [
      {
        "id":1,
        "name": "101",
        "start_hour": 10,
        "start_minute": 15,
        "duration_hours": 1.75,
        "weekday" : "Monday, Wednesday",
        "room" : "105",
        "gsi" : {}
        "created_at":"2015-06-09T01:08:39.146Z",
        "url":"#{resourceUrl}/1"
      },
      {
        "id":2,
        "name": "102",
        "start_hour": 12,
        "start_minute": 0,
        "duration_hours": 2,
        "weekday" : "Monday, Wednesday",
        "room" : "111",
        "gsi" : {}
        "created_at":"2015-06-09T01:08:46.749Z",
        "url":"#{resourceUrl}/2"
      },
      {
        "id":3,
        "name": "103",
        "start_hour": 14,
        "start_minute": 0,
        "duration_hours": 2,
        "weekday" : "Tuesday, Thursday",
        "room" : "105",
        "gsi" : {}
        "created_at":"2015-06-09T01:08:46.749Z",
        "url":"#{resourceUrl}/3"
      }
    ]

    createdResource = {
      "id":4,
      "name": "106",
      "start_hour": 12,
      "start_minute": 30,
      "duration_hours": 1,
      "weekday" : "Friday",
      "room" : "105",
      "gsi" : {}
      "created_at":"2015-06-09T01:08:39.146Z",
      "url":"#{resourceUrl}/4"
    }

    successCallback = jasmine.createSpy('successCallback')
    errorCallback = jasmine.createSpy('errorCallback')

# Function that checks if the Response object has the same
# content as the original hash
  expectToMatch = (response, original) ->
    for key, value of original
      expect(response[key]).toEqual(original[key])

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      return

    inject (_Section_) ->
      Resource = _Section_
      Resource.init(course_id)





  describe "all(successCallback)", ->
    it "returns the list of all resources and calls the successCallback", ->
      $httpBackend.expectGET(resourcePath).respond(200, allFakeResources)
      resources = Resource.all(successCallback)
      $httpBackend.flush()
      expect(successCallback).toHaveBeenCalled()
      for resource, id in resources
        expectToMatch resource, allFakeResources[id]

  describe "remove(resource, successCallback)", ->
    removeCourse = (resource) ->
      id = resource['id']
      $httpBackend.expectDELETE("#{resourcePath}/#{id}")
        .respond(204, '')
      Resource.remove resource, successCallback
      $httpBackend.flush()

    it "sends a DELETE request to the correct route", ->
      resources = GetAllResources()
      removeCourse resources[2], successCallback
      expect(successCallback).toHaveBeenCalled()


  describe "saveNew(resource)", ->
    saveNewResource = (resource) ->
      $httpBackend.expectPOST(resourcePath).respond(201, createdResource)
      Resource.saveNew resource, successCallback
      $httpBackend.flush()

    it "sends a POST request to the correct route", ->
      courses = GetAllResources()
      saveNewResource createdResource
      expect(successCallback).toHaveBeenCalled()


  describe "update(resource)", ->
    newName = "342"
    updateResource = (resource, newName) ->
      id = resource['id']
      updatedResource = angular.copy(allFakeResources[id-1])
      updatedResource['name'] = newName
      $httpBackend.expectPUT().respond(200, updatedResource)
      Resource.update resource, successCallback
      $httpBackend.flush()

    it "sends a PUT request to the correct route", ->
      resources = GetAllResources()
      updateResource resources[2], newName
      expect(successCallback).toHaveBeenCalled()



      