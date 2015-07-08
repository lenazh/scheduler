@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    scope: {
      user: '='
    },
    templateUrl: 'calendar_template.html',
    controller: ['$scope', 'Section', ($scope, Section) ->

# Some fake data to get a feeling of how direcrives interact
# with each other and services before doing the proper coding

      $scope.events = {}
      $scope.events['Monday1200pm'] = {
        name: "Do some work",
        start: "12:15pm",
        end: "2pm",
        room: "275 Birge",
        duration_hours: 1.75 
      }

      $scope.events['Monday600pm'] = {
        name: "Go home",
        start: "6:00pm",
        end: "7:30pm",
        room: "none",
        duration_hours: 1.5 
      }

      $scope.events['Tuesday200pm'] = {
        name: "Eat food",
        start: "2:30pm",
        end: "3:00pm",
        room: "home",
        duration_hours: 0.5
      }

      $scope.events['Friday700pm'] = {
        name: "Walk a dog",
        start: "7:00pm",
        end: "8:00pm",
        room: "(outside)",
        duration_hours: 2
      }


# This is needed for the calendar to build
      $scope.weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      $scope.hours = []
      $scope.hours.push "#{x}:00am" for x in [8..11]
      $scope.hours.push "12:00pm"
      $scope.hours.push "#{x}:00pm" for x in [1..8]

# This is where the events are supposed to come from
#      $scope.events = Section.all();

      getName = (weekday, hour) ->
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