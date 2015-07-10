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

# Date function returns BS
  getMinutes = (timestamp) ->
    date = new Date(Date.parse(timestamp))
    console.log "#{timestamp} -> #{date} "
    minutes = date.getMinutes()
     
  getHours = (timestamp) -> 
    date = new Date(Date.parse(timestamp))
    console.log "#{timestamp} -> #{date} "
    hours = date.getHours()

  timeToString = (timestamp) ->
    minutes = getMinutes(timestamp)
    minutes = "0#{minutes}" ? minutes < 10 : "#{minutes}" 
    "#{getHours(timestamp)}:#{minutes}"

  parseSectionTime = (section) ->
    time = {}
    time['start_minutes'] = getMinutes section['start_time']
    time['start_hours'] = getHours section['start_time']
    time['end_minutes'] = getMinutes section['end_time']
    time['end_hours'] = getHours section['end_time']
    time

  getStyle = (section) ->
    time = parseSectionTime section
    style = {}
    style['top'] = (time['start_minutes'] * 100) / 60 + "%"
    style['height'] = (time['end_hours'] - time['start_hours'] + 
      (time['end_minutes'] - time['start_minutes'])/60) * 100 + "%"
    style

  processSection = (rawSection) ->
    section = {}
    section['name'] = rawSection['name']
    section['room'] = rawSection['room']
    section['weekday'] = rawSection['weekday']
    section['start_time'] = rawSection['start_time']
    section['end_time'] = rawSection['end_time']
    section['start'] = timeToString rawSection['start_time']
    section['end'] = timeToString rawSection['end_time']
    section['weekdays'] = rawSection['weekday'].split /[, ]+/
    section['style'] = getStyle section
    section

  newSection = (hour, weekday) ->
    section = {
      name: "New Section",
      'start_time': hour,
      'end_time': "-",
      room: "-",
      style: {'top': '0%'; 'height': '200%'}
    }
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
        pushSection(getStartHour(section), weekday, section)


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