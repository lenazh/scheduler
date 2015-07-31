@schedulerModule.controller 'GsiCtrl',
  ['$scope', '$routeParams', 'Employment', ($scope, $routeParams, Employment) ->
    new schedulerApp.EmploymentFormController($scope, $routeParams, Employment)
]