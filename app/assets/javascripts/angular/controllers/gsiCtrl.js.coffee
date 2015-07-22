@schedulerModule.controller 'gsiCtrl',  ['$scope', 'Gsi', ($scope, Gsi) ->

  @gsis = Gsi.all()
  @email = ''
  @hoursPerWeek = ''

  @hideAddButton = false
  @hideUpdateButton = true
  @disableEditingAndDeletion = false

  form_is_valid = () ->
    form = $scope.form
    form.email.$valid && form.hours_per_week.$valid

  @remove = (gsi) -> 
    Gsi.remove gsi

  @saveNew = () ->
    return unless form_is_valid
    Gsi.saveNew {
        'name': '-', 
        'email': @email,
        'hours_per_week': @hoursPerWeek
      }
    @email = ""

  @update = () ->
    return unless form_is_valid
    gsi = @gsiToUpdate
    name = @email
    Gsi.update gsi, name
    @addForm()

  @editForm = (gsi) ->
    @hideAddButton = true
    @hideUpdateButton = false
    @disableEditingAndDeletion = true
    @gsiToUpdate = gsi
    @email = gsi.name



  @addForm = () ->
    @hideAddButton = false
    @hideUpdateButton = true
    @disableEditingAndDeletion = false
    @email = ""




# The controller will not work w/o this 
# return statement as the coffescript will
# try to return the last defined method

  return
]