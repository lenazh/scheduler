@schedulerModule.controller 'CalendarEventCtrl', ['$scope', ($scope) ->
# TODO -- allow the event to be controlled from keyboard
  if $scope.event.gsi
    $scope.gsiId = $scope.event.gsi.id
  else
    $scope.gsiId = null

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

  $scope.setGsi = (gsiId)->
    $scope.sectionCalendar.setGsi(
      $scope.event
      gsiId
      ->
      ->
        if $scope.event.gsi
          $scope.gsiId = $scope.event.gsi.id
        else
          $scope.gsiId = null
    )

# TODO - move this to filters
  getPreference = (gsi) ->
    value = gsi.preference
    return "REALLY wants this section" if value >= 1.0
    return "Wants this section" if 1.0 > value >= 0.75
    return "OK with this section" if 0.75 > value >= 0.5
    return "Doesn't like this section" if 0.5 > value >= 0.25
    return "REALLY dislikes this section" if 0.25 > value > 0
    return "Can't make it" if value == 0

  $scope.gsiLabel = (gsi) ->
    "#{gsi.name} (#{getPreference(gsi)})"

  $scope.pad = (minutes) ->
    if (minutes < 10)
      return "0" + minutes
    else
      return minutes

  return
]