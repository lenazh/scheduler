@schedulerModule.directive 'calendarEvent', ->
  {
    restrict: 'E',
    scope: {
      event: '='
      weekday: '='
      hour: '='
    },
    require: '^sectionCalendar'
    templateUrl: 'event_template.html',
    controller: 'CalendarEventCtrl',
    link: (scope, element, attrs, sectionCalendar) ->
      isGhost = () ->
        (scope.event.id == 0)

      scope.sectionCalendar = sectionCalendar
      scope.editStyle = {height: 'auto', width: '30em', 'z-index': '200'}
      scope.isGhost = isGhost()
      scope.showEditForm = isGhost()
      scope.element = element
  }