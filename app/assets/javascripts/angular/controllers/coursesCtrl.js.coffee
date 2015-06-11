@coursesModule.controller 'coursesCtrl', ['$scope', 'Course', ($scope, Course) ->
  $scope.courses = Course.query()
]