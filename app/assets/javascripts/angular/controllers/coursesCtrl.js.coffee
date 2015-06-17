@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  Course.init()
  $scope.courses = Course.all()
  $scope.courseName = ""
  $scope.courseToUpdate = {}
  $scope.hideAddButton = false
  $scope.hideUpdateButton = true
  $scope.disableEditingAndDeletion = false



  $scope.remove = (course) ->
    id = $scope.courses.indexOf course
    return if id == -1
    $scope.courses.splice id, 1
    Course.remove course 



  $scope.saveNew = () ->
    return unless $scope.form.courseName.$valid
    name = $scope.courseName
    $scope.courses.push Course.saveNew(name)
    $scope.courseName = ""



  $scope.update = () ->
    return unless $scope.form.courseName.$valid
    course = $scope.courseToUpdate
    name = $scope.courseName
    id = $scope.courses.indexOf course    
    return if id == -1

    result = Course.update course, name, -> $scope.courses[id]["name"] = name
    $scope.addForm()


  $scope.editForm = (course) ->
    $scope.hideAddButton = true
    $scope.hideUpdateButton = false
    $scope.disableEditingAndDeletion = true
    $scope.courseToUpdate = course
    $scope.courseName = course.name



  $scope.addForm = () ->
    $scope.hideAddButton = false
    $scope.hideUpdateButton = true
    $scope.disableEditingAndDeletion = false
    $scope.courseName = ""



  $scope.select = (course) ->
    null
]