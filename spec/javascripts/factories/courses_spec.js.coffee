describe "Courses", ->
# define the local variables
  Courses = {}
  $httpBackend = {}
  resoursePath = "/api/courses"

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

# initialize the dependencies and get the objects
  beforeEach module('coursesApp')
  beforeEach ->
    inject ($injector) ->
      $httpBackend = $injector.get '$httpBackend'
      Courses = $injector.get 'Courses'
      return


  it "has init() function", ->
    expect(Courses.init()).toBeDefined()

  it "has all() function that returns the list of all courses", ->
    $httpBackend.expectGET(resoursePath).respond(allCourses)
    result = Courses.all()
    $httpBackend.flush()
    expect(result).toEqual(allCourses)

  it "has remove(course) function that removes the given course", ->
    $httpBackend.expectDELETE('#{resoursePath}/2')
      .respond(204, '')
    result = Courses.remove {id: 2}
    $httpBackend.flush()

  it "has saveNew(name) function that creates a new course with the given name", ->
    $httpBackend.expectPOST(resoursePath, "name=#{newCourse.name}")
      .respond(201, newCourse)
    result = Courses.saveNew newCourse.name
    $httpBackend.flush()
    expect(result).toEqual(newCourse)

  it "has update(course, name) function that updates the given course with the name", ->
    updatedCourses = allCourses
    newName = "Blahblahology 101"
    id = 1
    updatedCourses[id].name = newName
    $httpBackend.expectPOST(resoursePath, "name=#{newCourse.name}/#{id+1}")
      .respond(200, updatedCourses[id])
    result = Courses.update(allCourses[id], newCourse.name)
    $httpBackend.flush()
    expect(result).toEqual(updatedCourses)