@schedulerModule.controller 'CalendarEventCtrl', ['$scope', ($scope) ->
# TODO -- allow the event to be controlled from keyboard
  resetGsiSelector = ->
    if $scope.event.gsi
      $scope.gsiId = $scope.event.gsi.id
    else
      $scope.gsiId = null

  gsiClass = (gsi) ->
    return "cant-make" unless gsi
    value = gsi.preference
    return "really-wants-section" if value >= 1.0
    return "wants-section" if 1.0 > value >= 0.75
    return "ok-with-section" if 0.75 > value >= 0.5
    return "doesnt-like-section" if 0.5 > value >= 0.25
    return "really-dislikes" if 0.25 > value > 0
    return "cant-make" if value == 0

  $scope.availableGsis = angular.copy $scope.event.available_gsis
  $scope.availableGsis.push { id: null, name: '(nobody)', preference: 0.0}

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

  $scope.new = ($event) ->
    hour = $scope.hour
    weekday = $scope.weekday
    $scope.sectionCalendar.emptyCellOnClick(hour, weekday)
    $event.stopPropagation()

  $scope.setGsi = (gsiId)->
    $scope.sectionCalendar.setGsi(
      $scope.event
      gsiId
      ->
      -> resetGsiSelector()
    )

  $scope.eventClass = ->
    "event #{gsiClass($scope.event.gsi)}"

  resetGsiSelector()

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
    if gsi.id
      "#{gsi.name} (#{getPreference(gsi)})"
    else
      "(none)"

  $scope.pad = (minutes) ->
    if (minutes < 10)
      return "0" + minutes
    else
      return minutes

  return
]