@schedulerModule.directive 'calendarEvent', ->
  {
    restrict: 'E',
    scope: {
      event: '='
    },
    templateUrl: 'event_template.html',
    link: (scope, element, attr, sectionCalendar) ->
      return
  }