@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    scope: {
      user: '=',
      hours: '=',
      weekdays: '='
    },
    templateUrl: 'calendar_template.html',
    controller: ['$scope', ($scope) ->
      $scope.getName = (weekday, hour) ->
        weekday + hour.replace /:/, ''
    ]
  }