@schedulerModule.controller 'AppointmentsCtrl', 
  ['$scope', 'Navbar', 'Appointment', ($scope, Navbar, Appointment) ->
    new schedulerApp.AppointmentFormController($scope, Navbar, Appointment)
]
