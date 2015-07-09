@schedulerModule.directive 'calendarEvent', ->
  {
    restrict: 'E',
    scope: {
      event: '='
    },
    require: '^sectionCalendar'
    templateUrl: 'event_template.html',
    controller: 'calendarEventCtrl',
    link: (scope, element, attrs, sectionCalendar) ->
      scope.sectionCalendar = sectionCalendar
      scope.styleEdit = {height: 'auto', width: 'auto', 'z-index': '200'}
      scope.styleView = scope.event.style
      scope.eventStyle = scope.styleView
      scope.showEditForm = false
  }