@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    scope: {
      user: '='
    },
    templateUrl: 'calendar_template.html',
    controller: ['$scope', 'Section', ($scope, Section) ->

      $scope.cells = {}
      $scope.cells['Monday1200pm'] = "Do some work"
      $scope.cells['Monday600pm'] = "Go home"
      $scope.cells['Tuesday200pm'] = "Eat food"
      $scope.cells['Friday700pm'] = "Walk a dog"

      $scope.weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      $scope.hours = []
      $scope.hours.push "#{x}:00am" for x in [8..11]
      $scope.hours.push "12:00pm"
      $scope.hours.push "#{x}:00pm" for x in [1..8]

#      $scope.events = Section.all();

      $scope.getName = (weekday, hour) ->
        weekday + hour.replace /:/, ''
      @newEvent = (hour, weekday) ->
        alert "New event created at #{weekday} #{hour} !"
      @deleteEvent = (id) ->
        alert "Event deleted!"
      @updateEvent = (id, event) ->
        alert "Event updated!"

      return
    ]
  }