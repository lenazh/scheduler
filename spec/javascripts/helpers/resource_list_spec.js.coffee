describe "ResourceList", ->
  # define the local variables
  list = {}
  $httpBackend = {}
  $resource = {}
  resourceName = 'gsi'
  # which course this resource belongs to
  course_id = 1
  coursesPath = "/api/courses"
  resourcePath = "#{coursesPath}/#{course_id}/gsis"
  hostPath = "http://192.168.56.101:3000"
  resourceUrl = "#{hostPath}#{resourcePath}"
  fields = []
  params = {}
  gon = {}

  # canned responses defined here
  allResources = {}
  newGsi = {}
  gon = {}

  beforeEach ->
    allResources = [
      {
        "id": 1,
        "name": "Darth Vader",
        "email": "vader@deathstar.mil",
        "hours_per_week": 20,
        "created_at": "2015-06-09T01:08:39.146Z",
        "url": "#{resourceUrl}/1"
      },
      {
        "id": 2,
        "name": "Sponge Bob Square Pants",
        "email": "bob@gmail.com"
        "hours_per_week": 20,
        "created_at": "2015-06-09T01:08:46.749Z",
        "url": "#{resourceUrl}/2"
      },
      {
        "id": 3,
        "name": "Alice",
        "email": "alice.wickerbottom@gmail.com"
        "hours_per_week": 10
        "created_at": "2015-06-09T01:08:46.749Z",
        "url": "#{resourceUrl}/3"
      }
    ]

    newGsi = {
      "id": 4,
      "name": "Schnubbels",
      "email": "schnubb@kittyverse.gov",
      "hours_per_week": 5,
      "created_at": "2015-06-09T01:08:39.146Z",
      "url": "#{resourceUrl}/4"
    }

    fields = ['id', 'email', 'hours_per_week']

  # Function that checks if the Response object has the same
  # content as the original hash
  expectToMatch = (response, original) ->
    for field in fields
      expect(response[field]).toEqual(original[field])

  # Makes the call that returns all existing resources
  getAllResources = ->
    response = angular.copy(allResources)
    $httpBackend.expectGET(resourcePath).respond(200, response)
    all = list.all()
    $httpBackend.flush()
    all

# initialize the dependencies and get the objects
  beforeEach ->
    gon = {}
    window.gon = gon
  beforeEach module('schedulerApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      $resource = $injector.get '$resource'
      return
  beforeEach ->
    list = new schedulerApp.ResourceList(
      $resource, resourcePath + '/:id', resourceName)

  it "has method all() that returns the list of all resources", ->
    $httpBackend.expectGET(resourcePath).respond(200, allResources)
    result = list.all()
    $httpBackend.flush()
    for resource, id in result
      expectToMatch resource, allResources[id]

  describe "remove(resource)", ->
    removeResource = (resource) ->
      id = resource['id']
      $httpBackend.expectDELETE("#{resourcePath}/#{id}")
        .respond(204, '')
      list.remove resource
      $httpBackend.flush()

    it "sends a DELETE request to the correct route", ->
      resources = getAllResources()
      removeResource resources[2]
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "removes this resource from the list of all resources", ->
      resources = getAllResources()
      expect(resources.length).toEqual allResources.length
      removeResource resources[1]
      expect(resources.length).toEqual(allResources.length - 1)
      expect(resources[1].id).not.toEqual allResources[1].id

  describe "saveNew(gsi)", ->
    saveNewResource = ->
      $httpBackend.expectPOST(resourcePath).respond(201, newGsi)
      list.saveNew newGsi
      $httpBackend.flush()

    it "sends a POST request to the correct route", ->
      resources = getAllResources()
      saveNewResource()
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "appends the new resource to the list of all resources", ->
      resources = getAllResources()
      saveNewResource()
      expect(resources.length).toEqual allResources.length + 1
      expectToMatch(resources[resources.length - 1], newGsi)

  describe "update(resource, params)", ->
    beforeEach ->
      params = {
        'email': 'root@aperture-science.com',
        'hours_per_week': 168
      }

    updateResponse = (resource, params) ->
      id = resource['id']
      updatedCourse = angular.copy(allResources[id-1])
      params['id'] = id
      for field in fields
        updatedCourse[field] = params[field]
      updatedCourse

    updateResource = (resource, params) ->
      $httpBackend.expectPUT().respond(200, updateResponse(resource, params))
      list.update resource, params
      $httpBackend.flush()

    it "sends a PUT request to the correct route", ->
      resources = getAllResources()
      updateResource resources[2], params
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "updates the resource in the list of all resources", ->
      id = 0
      resources = getAllResources()
      for field in fields
        expect(resources[id][field]).not.toEqual params[field]
      updateResource resources[id], params
      for field in fields
        expect(resources[id][field]).toEqual params[field]
