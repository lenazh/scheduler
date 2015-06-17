@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  Course.init()
  $scope.courses = Course.all()

  $scope.remove = (course) ->
    id = $scope.courses.indexOf course
    if (id != -1)
      $scope.courses.splice id, 1
    Course.remove course 

  $scope.saveNew = (name) ->
    $scope.courses.push Course.saveNew(name)

  $scope.update = (course, name) ->
    id = $scope.courses.indexOf course
    if (id != -1)
      result = Course.update course, name, -> $scope.courses[id]["name"] = name
      return result
    null

  $scope.select = (course) ->
    null
]