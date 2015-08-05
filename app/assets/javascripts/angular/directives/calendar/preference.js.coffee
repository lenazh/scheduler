@schedulerModule.directive 'calendarPreference', ->
  {
    restrict: 'E',
    scope: {
      event: '='
    },
    require: '^sectionCalendar'
    templateUrl: 'preference_template.html',
    controller: 'CalendarPreferenceCtrl',
    link: (scope, element, attrs, sectionCalendar) ->
      scope.sectionCalendar = sectionCalendar
      scope.editStyle = {height: 'auto', width: 'auto', 'z-index': '200'}
      scope.showEditForm = false
  }