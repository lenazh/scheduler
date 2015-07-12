@schedulerModule.controller 'calendarEventCtrl', ['$scope', ($scope) ->
# TODO -- allow the event to be controlled from keyboard

  $scope.toggleExpand = ($event) ->
    if $scope.isGhost
      $event.stopPropagation()
      return

    if $scope.showEditForm
      $scope.sectionCalendar.updateSection(
        $scope.event
        -> $scope.showEditForm = !$scope.showEditForm
      )
    else
      $scope.showEditForm = !$scope.showEditForm
    $event.stopPropagation()

  $scope.update = ($event) ->
    $scope.sectionCalendar.updateSection(
      $scope.event
      ->
    )
    $event.stopPropagation()

  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()

  $scope.delete = ($event) ->
    $scope.sectionCalendar.deleteSection($scope.event)
    $event.stopPropagation()

  $scope.save = ($event) ->
    $scope.sectionCalendar.saveSection(
      $scope.event
      -> $scope.showEditForm = !$scope.showEditForm
    )
    $event.stopPropagation()

  $scope.cancel = ($event) ->
    $scope.sectionCalendar.deleteGhost($scope.event)
    $event.stopPropagation()

# TODO - move this to filters
  $scope.pad = (minutes) ->
    if (minutes < 10)
      return "0" + minutes
    else
      return minutes

  return
]