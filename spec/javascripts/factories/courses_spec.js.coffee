describe "Courses", ->
# define the local variables
  Courses = {}
  $httpBackend = {}
  resourcePath = "/api/courses"
  hostPath = "http://192.168.56.101:3000"
  resourceUrl = "#{hostPath}#{resourcePath}"

# canned responses defined here
  allCourses = {}
  newCourse = {}

  beforeEach ->
    allCourses = [
      {
        "id":1,
        "name":"Class 1",
        "user_id":1,
        "created_at":"2015-06-09T01:08:39.146Z",
        "url":"#{resourceUrl}/1"
      },
      {
        "id":2,
        "name":"Class 2",
        "user_id":1,
        "created_at":"2015-06-09T01:08:46.749Z",
        "url":"#{resourceUrl}/2"
      },
      {
        "id":3,
        "name":"Class 3",
        "user_id":1,
        "created_at":"2015-06-09T01:08:46.749Z",
        "url":"#{resourceUrl}/3"
      }
    ]

    newCourse = {
      "id":4,
      "name":"Class 4",
      "user_id":1,
      "created_at":"2015-06-09T01:08:39.146Z",
      "url":"#{resourceUrl}/4"
    }

# Function that checks if the Response object has the same
# content as the original hash
  expectToMatch = (response, original) ->
    expect(response['id']).toEqual(original['id'])
    expect(response['name']).toEqual(original['name'])
    expect(response['user_id']).toEqual(original['user_id'])

# Makes the call that returns all existing courses
  getAllCourses = ->
    $httpBackend.expectGET(resourcePath).respond(200, allCourses)
    allCoursesResources = Courses.all()
    $httpBackend.flush()
    allCoursesResources

# stub out gon
  window.gon = {}
  gon.courses_api_path = resourcePath

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      return

    inject (_Course_) ->
      Courses = _Course_


  it "has method all() that returns the list of all courses", ->
    $httpBackend.expectGET(resourcePath).respond(200, allCourses)
    result = Courses.all()
    $httpBackend.flush()
    for course, id in result
      expectToMatch course, allCourses[id]

  describe "remove(course)", ->
    removeCourse = (course, id) ->
      id = course['id']
      $httpBackend.expectDELETE("#{resourcePath}/#{id}")
        .respond(204, '')
      Courses.remove course 
      $httpBackend.flush()

    it "sends a DELETE request to the correct route", ->
      courses = getAllCourses()
      removeCourse courses[2]
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "removes this course from the list of all courses", ->
      courses = getAllCourses()
      removeCourse courses[1]
      expect(courses.length).toEqual allCourses.length - 1
      expect(courses[1].id).not.toEqual allCourses[1].id

  describe "saveNew(name)", ->
    saveNewCourse = (name) ->
      $httpBackend.expectPOST(resourcePath, "{\"name\":\"#{name}\"}")
        .respond(201, newCourse)
      Courses.saveNew name
      $httpBackend.flush()

    it "sends a POST request to the correct route", ->
      courses = getAllCourses()
      saveNewCourse newCourse['name']
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "appends the new course to the list of all courses", ->
      courses = getAllCourses()
      saveNewCourse newCourse['name']
      expect(courses.length).toEqual allCourses.length + 1
      expect(courses[courses.length - 1].name).toEqual newCourse.name

  describe "update(course, name)", ->
    newName = "Blahblahology101"
    updateCourse = (course, newName) ->
      id = course['id']
      updatedCourse = angular.copy(allCourses[id-1])
      updatedCourse['name'] = newName
      $httpBackend.expectPUT("#{resourcePath}/#{id}?course%5Bname%5D=#{newName}")
        .respond(200, updatedCourse)
      Courses.update course, newName
      $httpBackend.flush()

    it "sends a PUT request to the correct route", ->
      courses = getAllCourses()
      updateCourse courses[2], newName
      expect(true).toBe(true) # no expectation other than the $httpBackend call

    it "updates the course name in the list of all courses", ->
      id = 0
      courses = getAllCourses()
      expect(courses[id].name).not.toEqual newName
      updateCourse courses[id], newName
      expect(courses[id].name).toEqual newName


      