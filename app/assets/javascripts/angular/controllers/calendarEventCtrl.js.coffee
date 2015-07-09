@schedulerModule.controller 'calendarEventCtrl', ['$scope', ($scope) ->
  $scope.toggleExpand = ($event) ->
    $scope.showEditForm = !$scope.showEditForm
    if $scope.showEditForm
      $scope.eventStyle = $scope.styleEdit
    else
      $scope.eventStyle = $scope.styleView

    $event.stopPropagation()

  $scope.stopPropagation = ($event) ->
    $event.stopPropagation()

  $scope.update = ($event) ->
    $scope.sectionCalendar.updateEvent($scope.event)
    $scope.toggleExpand($event)
    $event.stopPropagation()

  $scope.delete = ($event) ->
    $scope.sectionCalendar.deleteEvent($scope.event)
    $event.stopPropagation()

  return
]