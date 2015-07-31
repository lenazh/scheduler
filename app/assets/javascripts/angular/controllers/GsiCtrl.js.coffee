class EmploymentFormController extends schedulerApp.FormController
  $scope = {}

  constructor: (_$scope_, $routeParams, Employment) ->
    course_id = $routeParams['course_id']
    Employment.init(course_id)
    super Employment, ['email', 'hours_per_week']
    $scope = _$scope_

  form_is_valid: ->
    form = $scope.form
    form.email.$valid && form.hours.$valid

schedulerApp.EmploymentFormController = EmploymentFormController

@schedulerModule.controller 'GsiCtrl',
  ['$scope', '$routeParams', 'Employment', ($scope, $routeParams, Employment) ->
    new schedulerApp.EmploymentFormController($scope, $routeParams, Employment)
]