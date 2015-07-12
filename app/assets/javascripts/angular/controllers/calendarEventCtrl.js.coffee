@schedulerModule.controller 'calendarEventCtrl', ['$scope', ($scope) ->
  update_event = () ->
    $scope.sectionCalendar.updateSection($scope.event)

  $scope.toggleExpand = ($event) ->
    $scope.showEditForm = !$scope.showEditForm
    update_event() unless $scope.showEditForm
    $event.stopPropagation()

  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()

  $scope.delete = ($event) ->
    $scope.sectionCalendar.deleteSection($scope.event)
    $event.stopPropagation()

# TODO - move this to filters
  $scope.pad = (minutes) ->
    if (minutes < 10)
      return "0" + minutes
    else
      return minutes

  return
]