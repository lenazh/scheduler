@schedulerModule.controller 'CoursesCtrl', 
  ['$scope', 'Navbar', 'Course', ($scope, Navbar, Course) ->
    new schedulerApp.CourseFormController($scope, Navbar, Course)
]
