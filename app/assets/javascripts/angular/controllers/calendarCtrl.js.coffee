@schedulerModule.controller 'calendarCtrl',  ['$scope', '$routeParams', 'Section', ($scope, $routeParams, Section) ->

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

  addSectionIndexHelper = (section_id, cell_key) ->
    if (typeof sectionIndex[section_id] == 'undefined')
      sectionIndex[section_id] = []
    sectionIndex[section_id].push cell_key

  deleteSectionsHelper = (section_id) ->
    if (typeof sectionIndex[section_id] == 'undefined')
      return
    for key in sectionIndex[section_id]
      delete cells[key][section_id]
    sectionIndex[section_id] = []

  deleteGhostSections = () ->
    deleteSectionsHelper(ghostIndex)

  deleteSectionFromCells = (section) ->
    deleteSectionsHelper section['id']

  addSectionIntoIndex = (section, key) ->
    addSectionIndexHelper(section['id'], key)

  addSectionToCells = (rawSection) ->
    section = processSection rawSection
    for weekday in section['weekdays']
      placeSection getHourKey(section), weekday, section

  placeSection = (hour, weekday, section) ->
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
      section = processSection section
      addSectionToCells section

  saveSection = (section) ->
    Section.saveNew section, (newSection) ->
      deleteGhostSections()
      addSectionToCells newSection

  newGhostSection = (hour, weekday) ->
    deleteGhostSections()
    section = {
      'id': ghostIndex,
      'name': "New Section",
      'room': "-",
      'weekday': weekday
      'start_hour': hourKeyToHour(hour),
      'start_minute': 0,
      'duration_hours' : 2
    }
    addSectionToCells section
    

# Initialize the calendar
  weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  hours = []
  hours.push hourKey(x) for x in [8..20]
  cells = makeCells()
  sectionIndex = []
  ghostSectionIndex = []

  $scope.hours = hours
  $scope.weekdays = weekdays
  $scope.cells = cells

  ghostIndex = 0

  course_id = $routeParams['course_id']
  Section.init(course_id)
  Section.all (all) ->
    for section in all
      addSectionToCells section


## Expose the interface

  $scope.getSections = (hour, weekday) ->
    getSections(hour, weekday)

  $scope.newGhostSection = (hour, weekday) ->
    newGhostSection(hour, weekday)

  @saveSection = (section) ->
    saveSection(section)

  @deleteSection = (section) ->
    deleteSection(section)

  @updateSection = (section) ->
    updateSection(section)

  @getStyle = (section) ->
    getStyle(section)

  return
]