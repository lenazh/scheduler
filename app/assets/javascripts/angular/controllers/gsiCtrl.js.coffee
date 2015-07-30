class GsiFormController extends schedulerApp.FormController
  $scope = {}

  constructor: (_$scope_, $routeParams, Gsi) ->
    course_id = $routeParams['course_id']
    Gsi.init(course_id)
    super Gsi, ['email', 'hours_per_week']
    $scope = _$scope_

  form_is_valid: () ->
    form = $scope.form
    form.email.$valid && form.hours_per_week.$valid

schedulerApp.GsiFormController = GsiFormController

@schedulerModule.controller 'gsiCtrl', ['$scope', '$routeParams', 'Gsi', ($scope, $routeParams, Gsi) ->
  new schedulerApp.GsiFormController($scope, $routeParams, Gsi)
]