@schedulerModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->

  @courses = Course.all()
  @courseName = ""

  @hideAddButton = false
  @hideUpdateButton = true
  @disableEditingAndDeletion = false


  name_is_valid = () ->
    $scope.form.courseName.$valid

  @remove = (course) -> Course.remove course 

  @saveNew = () ->
    return unless name_is_valid
    name = @courseName
    Course.saveNew(@courseName)
    @courseName = ""

  @update = () ->
    return unless name_is_valid
    course = @courseToUpdate
    name = @courseName
    Course.update course, name
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



  @select = (course) -> null


# The controller will not work w/o this 
# return statement as the coffescript will
# try to return the last defined method

  return
]