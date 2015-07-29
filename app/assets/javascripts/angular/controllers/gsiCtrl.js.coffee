class GsiFormController extends schedulerApp.FormController
  $scope = {}
  $routeParams = {}
  Gsi = {}

  constructor: (_$scope_, $routeParams, Gsi) ->
    super Gsi, ['email', 'hours_per_week']
    course_id = $routeParams['course_id']
    Gsi.init(course_id)
    @all = Gsi.all()
    $scope = _$scope_

  form_is_valid: () ->
    form = $scope.form
    form.email.$valid && form.hours_per_week.$valid

  saveNew: () ->
    console.log @fields
    super
    @hours_per_week = 20

schedulerApp.GsiFormController = GsiFormController

@schedulerModule.controller 'gsiCtrl', ['$scope', '$routeParams', 'Gsi', ($scope, $routeParams, Gsi) ->
  new schedulerApp.GsiFormController($scope, $routeParams, Gsi)
]