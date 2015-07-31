@schedulerModule.controller 'AppointmentsCtrl', 
  ['$scope', 'Navbar', 'Appointment', ($scope, Navbar, Appointment) ->
    new schedulerApp.CourseFormController($scope, Navbar, Course)
]
