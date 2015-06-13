@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  $scope.courses = Course.all()

  $scope.remove = (id) ->
    Course.remove id 

  $scope.save = (name) ->
    Course.save {name: name}

  $scope.update = (id, name) ->
    Course.update id, name

  $scope.select = (id) ->
    null
]