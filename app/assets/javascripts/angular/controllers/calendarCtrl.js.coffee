@schedulerModule.controller 'calendarCtrl',  ['$scope', 'Section', ($scope, Section) ->

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

# This is where the events are supposed to come from
#      $scope.events = Section.all();

# The functions that do the work

  newSection = (hour, weekday) ->
    cells[getKey(hour, weekday)].push {
      name: "New Section",
      start: hour,
      end: "-",
      room: "-",
      style: {'top': '0%'; 'height': '200%'}
    }
    return

  getSections = (hour, weekday) ->
    cells[getKey(hour, weekday)]

  deleteSection = (event) ->
    return

  updateSection = (event) ->
    return

## Expose the interface

  $scope.getSections = (hour, weekday) ->
    getSections(hour, weekday)

  $scope.newSection = (hour, weekday) ->
    newSection(hour, weekday)

  @deleteSection = (event) ->
    deleteSection(event)

  @updateSection = (event) ->
    updateSection(event)


  return

]