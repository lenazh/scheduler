@schedulerModule.controller 'calendarCtrl',  ['$scope', 'Section', ($scope, Section) ->

# Helper functions
  getKey = (hour, weekday) ->
    return hours.indexOf(hour) * weekdays.length + 
      weekdays.indexOf(weekday)

  makeCells = () ->
    cells = []
    for hour in hours
      for weekday in weekdays
        key = getKey(hour, weekday)
        cells[key] = []
    cells

  pushSection = (hour, weekday, section) ->
    console.log "Pushing cells[#{getKey(hour, weekday)}], hour=#{hour}, weekday=#{weekday} timestamp=#{section['start_time']} "
    cells[getKey(hour, weekday)].push section

  getStyle = (section) ->
    style = {}
    style['top'] = (section['start_minute'] * 100) / 60 + "%"
    style['height'] = section['duration_in_hours'] + "%"
    style

  processSection = (section) ->
    newSection = {}
    oldSection = angular.copy section
    newSection['name'] = oldSection['name']
    newSection['room'] = oldSection['room']
    newSection['weekday'] = oldSection['weekday']
    newSection['start_hour'] = oldSection['start_hour']
    newSection['start_minute'] = oldSection['start_minute']
    newSection['duration_in_hours'] = oldSection['duration_in_hours']
    newSection['weekdays'] = oldSection['weekday'].split /[, ]+/
    newSection['style'] = getStyle newSection
    newSection

  newSection = (hour, weekday) ->
    section = {
      'name': "New Section",
      'room': "-",
      'weekday': weekday
      'start_hour': hour,
      'start_minute': 0,
      'duration_in_hours' : 2, 
    }
    section = processSection(section)
    pushSection(hour, weekday, section)

  getStartHour = (section) ->
    getHours(section['start_time']) + ":00"

  getSections = (hour, weekday) ->
    cells[getKey(hour, weekday)]

  deleteSection = (event) ->
    return

  updateSection = (event) ->
    return

# Initialize the calendar
  weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  hours = []
  hours.push "#{x}:00" for x in [8..20]
  cells = makeCells()

  $scope.hours = hours
  $scope.weekdays = weekdays
  $scope.cells = cells

  Section.all (all) ->
    for rawSection in all
      section = processSection rawSection
      for weekday in section['weekdays']
        pushSection("#{section['hour']}:00", weekday, section)


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