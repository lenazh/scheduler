@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    scope: {
      user: '='
    },
    templateUrl: 'calendar_template.html',
    controller: ['$scope', 'Section', ($scope, Section) ->

      $scope.weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      $scope.hours = []
      $scope.hours.push "#{x}:00am" for x in [8..11]
      $scope.hours.push "12:00pm"
      $scope.hours.push "#{x}:00pm" for x in [1..8]

#      $scope.events = Section.all();

      $scope.getName = (weekday, hour) ->
        weekday + hour.replace /:/, ''
      $scope.newEvent = (event) ->
        alert "New event created!"
      $scope.deleteEvent = (id) ->
        alert "Event deleted!"
      $scope.updateEvent = (id, event) ->
        alert "Event updated!"
    ]
  }