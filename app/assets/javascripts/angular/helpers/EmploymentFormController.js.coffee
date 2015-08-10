class EmploymentFormController extends schedulerApp.FormController
  $scope = {}
  $cookies = {}
  isOwner: false 

  constructor: (_$scope_, _$cookies_, Employment) ->
    $scope = _$scope_
    $cookies = _$cookies_
    course_id = $cookies.get 'course_id'
    @isOwner = $cookies.get('course_owner') == 'true'
    Employment.init(course_id)
    super Employment, ['email', 'hours_per_week']


  form_is_valid: ->
    form = $scope.form
    form.email.$valid && form.hours.$valid

schedulerApp.EmploymentFormController = EmploymentFormController