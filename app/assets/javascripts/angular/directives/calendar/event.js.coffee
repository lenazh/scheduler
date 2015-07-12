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
      scope.editStyle = {height: 'auto', width: 'auto', 'z-index': '200'}
      scope.showEditForm = false
  }