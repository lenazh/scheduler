@schedulerModule.directive 'calendarEvent', ->
  {
    restrict: 'E',
    scope: {
      event: '=',
      deleteEvent: '&',
      updateEvent: '&'
    },
    require: '^sectionCalendar'
    templateUrl: 'event_template.html',
    controller: ['$scope',  ($scope) ->

      styleEdit = {height: 'auto', width: 'auto', 'z-index': '200'}
      styleView = $scope.event.style
      eventStyle = styleView
      showEditForm = false

      $scope.showEditForm = showEditForm
      $scope.eventStyle = eventStyle

      $scope.toggleExpand = ($event) ->
        $scope.showEditForm = !$scope.showEditForm
        if $scope.showEditForm
          $scope.eventStyle = styleEdit
        else
          $scope.eventStyle = styleView

        $event.stopPropagation()

      $scope.stopPropagation = ($event) ->
        $event.stopPropagation()

      $scope.update = ($event) ->
        $scope.updateEvent({event: event})
        $scope.toggleExpand($event)
        $event.stopPropagation()

      $scope.delete = ($event) ->
        $scope.deleteEvent({event: event})
        $event.stopPropagation()


      return
    ]
  }