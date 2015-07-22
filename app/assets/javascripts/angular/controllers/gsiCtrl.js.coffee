@schedulerModule.controller 'gsiCtrl', ['$scope', '$routeParams', 'Gsi', ($scope, $routeParams, Gsi) ->

  course_id = $routeParams['course_id']
  Gsi.init(course_id)
  @gsis = Gsi.all()
  @email = ''
  @hoursPerWeek = ''

  @hideAddButton = false
  @hideUpdateButton = true
  @disableEditingAndDeletion = false

  @form_is_valid = () ->
    form = $scope.form
    form.email.$valid && form.hours_per_week.$valid

  @remove = (gsi) -> 
    Gsi.remove gsi

  @saveNew = () ->
    return unless @form_is_valid
    Gsi.saveNew {
        'email': @email,
        'hours_per_week': @hoursPerWeek
      }
    @email = ''

  @update = () ->
    return unless @form_is_valid
    gsi = @gsiToUpdate
    params = {
      'email': @email
      'hours_per_week': @hoursPerWeek
    }
    Gsi.update gsi, params
    @addForm()

  @editForm = (gsi) ->
    @hideAddButton = true
    @hideUpdateButton = false
    @disableEditingAndDeletion = true
    @gsiToUpdate = gsi
    @email = gsi.email
    @hoursPerWeek = gsi.hours_per_week

  @addForm = () ->
    @hideAddButton = false
    @hideUpdateButton = true
    @disableEditingAndDeletion = false
    @email = ''
    @hoursPerWeek = ''


# The controller will not work w/o this 
# return statement as the coffescript will
# try to return the last defined method

  return
]