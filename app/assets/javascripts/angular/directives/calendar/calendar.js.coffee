@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    templateUrl: 'calendar_template.html',
    controller: 'CalendarCtrl'
  }