@schedulerModule.directive 'sectionCalendar', ->
  {
    restrict: 'E',
    scope: {
      user: '='
    },
    templateUrl: 'calendar_template.html',
    controller: ['$scope', 'Section', ($scope, Section) ->

# Initialize the calendar
      getKey = (hour, weekday) ->
        #weekday + hour.replace /:/, ''
        return hours.indexOf(hour) * weekdays.length + 
          weekdays.indexOf(weekday)

      makeCells = () ->
        cells = []
        for hour in hours
          for weekday in weekdays
            key = getKey(hour, weekday)
            cells[key] = []
        cells

      weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      hours = []
      hours.push "#{x}:00am" for x in [8..11]
      hours.push "12:00pm"
      hours.push "#{x}:00pm" for x in [1..8]
      cells = makeCells()

      $scope.hours = hours
      $scope.weekdays = weekdays
      $scope.cells = cells


# Some fake data to get a feeling of how direcrives interact
# with each other and services before doing the proper coding

      (cells[getKey('12:00pm', 'Monday')]).push {
        name: "Do some work",
        start: "12:15pm",
        end: "2pm",
        room: "275 Birge",
        style: {top: '25%'; height: '175%'}
      }

      (cells[getKey('6:00pm', 'Monday')]).push {
        name: "Go home",
        start: "6:00pm",
        end: "7:30pm",
        room: "none",
        style: {top: '0%'; height: '150%'}
      }

      (cells[getKey('2:00pm', 'Tuesday')]).push {
        name: "Eat food",
        start: "2:30pm",
        end: "3:00pm",
        room: "home",
        style: {top: '50%'; height: '50%'}
      }

      (cells[getKey('7:00pm', 'Friday')]).push {
        name: "Walk a dog",
        start: "7:00pm",
        end: "8:00pm",
        room: "(outside)",
        style: {top: '0%'; height: '200%'}
      }

      

# This is where the events are supposed to come from
#      $scope.events = Section.all();



# Expose the interface
      $scope.getEvents = (hour, weekday) ->
        cells[getKey(hour, weekday)]

      $scope.newEvent = (hour, weekday) ->
        cells[getKey(hour, weekday)].push {
          name: "New Event",
          start: "7:00pm",
          end: "-",
          room: "-",
          style: {'top': '0%'; 'height': '200%'}
        }
        return

      @deleteEvent = (id) ->
        alert "Event deleted!"
        return

      @updateEvent = (id, event) ->
        alert "Event updated!"
        return

      return
    ]
  }