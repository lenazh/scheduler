@schedulerModule.controller 'GsiCtrl',
  ['$scope', '$cookies', 'Employment', ($scope, $cookies, Employment) ->
    new schedulerApp.EmploymentFormController($scope, $cookies, Employment)
]