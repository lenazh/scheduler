@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  Course.init()
  $scope.courses = Course.all()
  $scope.courseName = ""
  $scope.hideAddButton = false
  $scope.hideUpdateButton = true
  $scope.disableEditingAndDeletion = false

  $scope.remove = (course) ->
    id = $scope.courses.indexOf course
    if (id != -1)
      $scope.courses.splice id, 1
    Course.remove course 

  $scope.saveNew = () ->
    if $scope.form.courseName.$valid
      name = $scope.courseName
      $scope.courses.push Course.saveNew(name)
      $scope.courseName = ""

  $scope.update = (course, name) ->
    id = $scope.courses.indexOf course
    if (id != -1)
      result = Course.update course, name, -> $scope.courses[id]["name"] = name
      return result
    null

  $scope.editForm = (course) ->
    $scope.hideAddButton = true
    $scope.hideUpdateButton = false
    $scope.disableEditingAndDeletion = true

  $scope.addForm = () ->
    $scope.hideAddButton = false
    $scope.hideUpdateButton = true
    $scope.disableEditingAndDeletion = false

  $scope.select = (course) ->
    null
]