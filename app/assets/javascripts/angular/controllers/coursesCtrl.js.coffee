@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  Course.init()
  $scope.courses = Course.all()

  $scope.remove = (course) ->
    Course.remove course 

  $scope.saveNew = (name) ->
    Course.saveNew name

  $scope.update = (course, name) ->
    Course.update course, name

  $scope.select = (course) ->
    null
]