@schedulerModule.controller 'calendarCtrl',  ['$scope', 'Section', ($scope, Section) ->

# Private functions
  getKey = (hour, weekday) ->
    return hours.indexOf(hour) * weekdays.length + 
      weekdays.indexOf(weekday)
  
  getHourKey = (section) ->
    hourKey section['start_hour']

  hourKey = (hour) ->
    hour + ":00"

  hourKeyToHour = (hourKey) ->
    parseInt hourKey.replace(/:00/, '')

  makeCells = () ->
    cells = []
    for hour in hours
      for weekday in weekdays
        key = getKey(hour, weekday)
        cells[key] = {}
    cells

  deleteSectionFromCells = (section) ->
    for key in sectionIndex[section['id']]
      delete cells[key][section['id']]
    sectionIndex[section['id']] = []

  addSectionIntoIndex = (section, key) ->
    if (typeof sectionIndex[section['id']] == 'undefined')
      sectionIndex[section['id']] = []
    sectionIndex[section['id']].push key

  addSectionToCells = (rawSection) ->
    section = processSection rawSection
    for weekday in section['weekdays']
      addSectionToCell getHourKey(section), weekday, section

  addSectionToCell = (hour, weekday, section) ->
    key = getKey(hour, weekday)
    index = cells[key].length
    addSectionIntoIndex section, key
    cells[key][section['id']] = section

  getStyle = (section) ->
    style = {}
    style['top'] = (section['start_minute'] * 100) / 60 + "%"
    style['height'] = section['duration_hours'] * 100 + "%"
    style

  isWithin = (value, min, max) ->
    if isNaN(value)
      return false
    else
      return false if (value < min) || (value > max)
    return true

  startHourValid = (section) ->
    start_hour = section['start_hour']
    isWithin start_hour, 0, 23
    
  startMinuteValid = (section) ->
    start_minute = section['start_minute']
    isWithin start_minute, 0, 59

  durationHoursValid = (section) ->
    duration_hours = section['duration_hours']
    isWithin duration_hours, 0, 10

  isSectionValid = (section) ->
    valid = startHourValid(section) && 
      startMinuteValid(section) &&
      durationHoursValid(section)
    for weekday in section['weekdays']
      if weekdays.indexOf(weekday) < 0
        valid = false
    return valid

  processSection = (section) ->
    newSection = angular.copy section
    newSection['weekdays'] = newSection['weekday'].split /[, ]+/
    newSection['style'] = getStyle newSection
    newSection['isValid'] = isSectionValid newSection
    newSection

  newSection = (hour, weekday) ->
    section = {
      'id': -1,
      'name': "New Section",
      'room': "-",
      'weekday': weekday
      'start_hour': hourKeyToHour(hour),
      'start_minute': 0,
      'duration_hours' : 2
    }
    Section.saveNew section, (newSection) ->
      addSectionToCells newSection

  getSections = (hour, weekday) ->
    cells[getKey(hour, weekday)]

  deleteSection = (section) ->
    Section.remove section, ->
      deleteSectionFromCells section
      
  updateSection = (section) ->
    section['weekdays'] = section['weekday'].split /[, ]+/
    section['isValid'] = isSectionValid section
    return unless section['isValid']
    Section.update section, ->
      deleteSectionFromCells section
      addSectionToCells section

# Initialize the calendar
  weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  hours = []
  hours.push hourKey(x) for x in [8..20]
  cells = makeCells()
  sectionIndex = []

  $scope.hours = hours
  $scope.weekdays = weekdays
  $scope.cells = cells

  course_id = 1 # fixme
  Section.init(course_id)
  Section.all (all) ->
    for section in all
      addSectionToCells section


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