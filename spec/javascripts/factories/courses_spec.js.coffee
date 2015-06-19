describe "Courses", ->
# define the local variables
  Courses = {}
  $httpBackend = {}
  resourcePath = "/api/courses"

# TODO: pass the resource path as a parameter with gon
# canned responses defined here
  allCourses = [
    {
      "id":1,
      "name":"Class 1",
      "user_id":1,
      "created_at":"2015-06-09T01:08:39.146Z",
      "url":"http://192.168.56.101:3000/api/courses/1"
    },
    {
      "id":2,
      "name":"Class 2",
      "user_id":1,
      "created_at":"2015-06-09T01:08:46.749Z",
      "url":"http://192.168.56.101:3000/api/courses/2"
    },
    {
      "id":3,
      "name":"Class 3",
      "user_id":1,
      "created_at":"2015-06-09T01:08:46.749Z",
      "url":"http://192.168.56.101:3000/api/courses/3"
    }
  ]

  newCourse = {
    "id":4,
    "name":"Class 4",
    "user_id":1,
    "created_at":"2015-06-09T01:08:39.146Z",
    "url":"http://192.168.56.101:3000/api/courses/4"
  }

# stub out gon
  window.gon = {}
  gon.courses_api_path = resourcePath

# initialize the dependencies and get the objects
  beforeEach module('coursesApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      return

    inject (_Course_) ->
      Courses = _Course_


  it "has init() function", ->
    expect(Courses.init()).toBeDefined()


  describe "I/O methods", ->
    beforeEach ->
      Courses.init()

    expectToMatch = (response, original) ->
      expect(response['id']).toEqual(original['id'])
      expect(response['name']).toEqual(original['name'])
      expect(response['user_id']).toEqual(original['user_id'])

    it "include all() that returns the list of all courses", ->
      $httpBackend.expectGET(resourcePath).respond(200, allCourses)
      result = Courses.all()
      $httpBackend.flush()
      for course, id in result
        expectToMatch course, allCourses[id]

    it "include remove(course) that removes the given course", ->
      $httpBackend.expectDELETE("#{resourcePath}/2")
        .respond(204, '')
      result = Courses.remove {id: 2}
      $httpBackend.flush()
      # removes SPEC HAS NO EXPECTATION message
      expect(true).toBe(true) 

    it "include saveNew(name) that creates a new course with the given name", ->
      $httpBackend.expectPOST(resourcePath, "{\"name\":\"#{newCourse.name}\"}")
        .respond(201, newCourse)
      result = Courses.saveNew newCourse.name
      $httpBackend.flush()
      expectToMatch result, newCourse

    it "include update(course, name) that updates the given course with the name", ->
      # Generate the resources array of all the existing courses
      $httpBackend.expectGET(resourcePath).respond(200, allCourses)
      allCoursesResources = Courses.all()
      $httpBackend.flush()

      # what the updated course should look like
      id = 1
      updatedCourse = allCourses[id]
      updatedCourseResource = allCoursesResources[id]
      expect(updatedCourse['id']).toEqual(id+1)
      expect(updatedCourseResource['id']).toEqual(id+1)
      newName = "Blahblahology101"

      #run the test
      $httpBackend.expectPUT("#{resourcePath}/#{id+1}?course%5Bname%5D=#{newName}")
        .respond(200, updatedCourse)
      result = Courses.update(updatedCourseResource, newName, ->)
      $httpBackend.flush()