@schedulerModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->

  Course.init()
  @courses = Course.all()
  @courseName = ""
  @courseToUpdate = {}
  @hideAddButton = false
  @hideUpdateButton = true
  @disableEditingAndDeletion = false


  @remove = (course) ->
    id = @courses.indexOf course
    return if id == -1
    @courses.splice id, 1
    Course.remove course 



  @saveNew = () ->
    return unless $scope.form.courseName.$valid
    name = @courseName
    @courses.push Course.saveNew(name)
    @courseName = ""



  @update = () ->
    return unless $scope.form.courseName.$valid
    course = @courseToUpdate
    name = @courseName
    id = @courses.indexOf course    
    return if id == -1

    courseToUpdate = @courses[id]
    result = Course.update course, name, -> courseToUpdate["name"] = name
    @addForm()


  @editForm = (course) ->
    @hideAddButton = true
    @hideUpdateButton = false
    @disableEditingAndDeletion = true
    @courseToUpdate = course
    @courseName = course.name



  @addForm = () ->
    @hideAddButton = false
    @hideUpdateButton = true
    @disableEditingAndDeletion = false
    @courseName = ""



  @select = (course) ->
    null


# The controller will not work w/o this 
# return statement as the coffescript will
# try to return the last defined method

  return
]