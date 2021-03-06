# This file needs to be refactored

# TODO
# Calendar needs to be a separate object or a factory
# Autoscheduler needs to construct without sections and GSIs
# and initialize when both become available and every time
# sections change

@schedulerModule.controller 'CalendarCtrl',
  ['$scope', '$cookies', 'Section', 'Employment',
  ($scope, $cookies, Section, Employment) ->

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

    makeCells = ->
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

    deleteGhostSections = ->
      deleteSectionsHelper(ghostIndex)

    deleteSectionFromCells = (section) ->
      deleteSectionsHelper section['id']

    addSectionIntoIndex = (section, key) ->
      addSectionIndexHelper(section['id'], key)

    addSectionToCells = (rawSection) ->
      section = processSection rawSection
      for weekday in section['weekdays']
        placeSection getHourKey(section), weekday, section

    redrawSection = (section) ->
      deleteSectionFromCells section
      addSectionToCells section

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
      isWithin start_hour, calendar_start_hour, calendar_end_hour

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
      newSection['weekdays'] = newSection['weekday'].split /[,; ]+/
      newSection['style'] = getStyle newSection
      newSection['isValid'] = isSectionValid newSection
      newSection['errors'] = {}
      newSection

    getSections = (hour, weekday) ->
      cells[getKey(hour, weekday)]

    deleteSection = (section) ->
      Section.remove section, ->
        deleteSectionFromCells section

    updateSection = (section, successCallback) ->
      Section.update(
        section
        (section) ->
          redrawSection section
          successCallback()
        (error) ->
          section['errors'] = error.data
      )

    setGsi = (section, gsi_id, successCallback, errorCallback) ->
      Section.setGsi(
        section
        gsi_id
        (section) ->
          redrawSection section
          successCallback section
        (error) ->
          section['errors'] = error.data
          errorCallback(error)
      )

    propose = (solution) ->
      for gsi, index in solution
        section = angular.copy sections[index]
        section.gsi = gsi
        redrawSection section

    unassignAll = () ->
      Section.clear (_sections) ->
        sections = _sections
        for section in sections
          redrawSection section

    resetCalendar = () ->
      Section.all (_sections) ->
        sections = _sections
        for section in sections
          redrawSection section

    saveSchedule = (solution) ->
      Section.clear (_sections) ->
        for gsi, index in solution
          section = sections[index]
          setGsi section, gsi.id, (->), (->)

    saveSection = (section, successCallback) ->
      Section.saveNew(
        section
        (newSection) ->
          deleteGhostSections()
          addSectionToCells newSection
          successCallback()
        (error) ->
          section['errors'] = error.data
      )

    deleteGhost = (section) ->
      deleteGhostSections()

    newGhostSection = (hour, weekday) ->
      deleteGhostSections()
      section = {
        'id': ghostIndex,
        'name': "New Section",
        'room': "-",
        'weekday': weekday
        'start_hour': hourKeyToHour(hour),
        'start_minute': 0,
        'duration_hours': 2
      }
      addSectionToCells section
      section

    emptyCellOnClick = (hour, weekday) ->
      if $scope.role == 'owner'
        return newGhostSection(hour, weekday)


  # Initialize the calendar
    weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    hours = []
    calendar_start_hour = gon.calendar_start_hour
    calendar_end_hour = gon.calendar_end_hour
    hours.push hourKey(x) for x in [calendar_start_hour..calendar_end_hour]
    cells = makeCells()
    sectionIndex = []
    ghostSectionIndex = []

    $scope.hours = hours
    $scope.weekdays = weekdays
    $scope.cells = cells

    ghostIndex = 0


    # Determines the type of events to be displayed
    isOwner = $cookies.get('course_owner') == 'true'
    isTeaching = $cookies.get('course_teaching') == 'true'
    $scope.roles = [
      {
        id: 1,
        value: 'owner',
        label: 'Sections'
      },
      {
        id: 2,
        value: 'gsi',
        label: 'Preferences'
      }
    ]

    if isOwner
      $scope.role = 'owner'
    else
      $scope.role = 'gsi'

    $scope.showSwitch = isOwner && isTeaching
    $scope.isOwner = isOwner

    # AutoScheduler data
    sections = []
    gsis = []
    scheduler = {}
    $scope.schedulerReady = false

    # Populate the calendar with events
    courseId = $cookies.get 'course_id'
    Section.init(courseId)
    Employment.init(courseId)
    Section.all (_sections) ->
      sections = _sections
      $scope.sections = _sections
      if isOwner
        Employment.roster (_gsis) ->
          gsis = _gsis
          scheduler = new schedulerApp.AutoScheduler(sections, gsis)
          $scope.schedulerReady = true if sections.length > 0

      for section in sections
        addSectionToCells section




  ## Expose the interface

    $scope.getSections = (hour, weekday) ->
      getSections(hour, weekday)

    $scope.emptyCellOnClick = (hour, weekday) ->
      emptyCellOnClick(hour, weekday)

    @emptyCellOnClick = (hour, weekday) ->
      emptyCellOnClick(hour, weekday)

    @saveSection = (section, successCallback) ->
      saveSection(section, successCallback)

    @deleteSection = (section) ->
      deleteSection(section)

    @deleteGhost = (section) ->
      deleteGhost(section)

    @updateSection = (section, successCallback) ->
      updateSection(section, successCallback)

    @getStyle = (section) ->
      getStyle(section)

    @setGsi = (section, gsi_id, successCallback, errorCallback) ->
      setGsi(section, gsi_id, successCallback, errorCallback)

    # button handlers for AutoScheduling
    $scope.schedulerReset = ->
      resetCalendar()

    $scope.schedulerFirst = ->
      if scheduler.first().length > 0
        propose(scheduler.solution())
      else
        alert 'There are no possible solutions'

    $scope.schedulerNext = ->
      if scheduler.next().length > 0
        propose(scheduler.solution())
      else
        alert 'There is no next solution'

    $scope.schedulerPrevious = ->
      if scheduler.previous().length > 0
        propose(scheduler.solution())
      else
        alert 'There is no previous solution'

    $scope.disableSchedulerSave = ->
      scheduler.solution().length == 0

    $scope.schedulerSave = ->
      if scheduler.solution().length > 0
        saveSchedule(scheduler.solution())

    $scope.schedulerHappiness = ->
      scheduler.quality() * 100

    $scope.schedulerUnemployed = ->
      scheduler.unemployed()

    $scope.schedulerSolvable = ->
      scheduler.solvable()

    $scope.displayUnemployed = ->
      (scheduler.quality() != 0.0) && (scheduler.unemployed().length > 0)

    $scope.displayGsisWithNoPreferences = ->
      scheduler.gsisWithNoPreferences().length > 0

    $scope.schedulerGsisWithNoPreferences = ->
      scheduler.gsisWithNoPreferences()

    $scope.displaySectionsNobodyCanTeach = ->
      scheduler.sectionsNobodyCanTeach().length > 0

    $scope.schedulerSectionsNobodyCanTeach = ->
      scheduler.sectionsNobodyCanTeach()

    $scope.unassignAll = ->
      unassignAll()

    $scope.schedulerStatus = ->
      scheduler.status()

    $scope.keepWithinTheSameLecture = true
    $scope.schedulerSameLectureChange = (value) ->
      scheduler.keepWithinTheSameLecture(value)

    $scope.schedulerWorstCase = ->
      scheduler.worstCase()

    $scope.cellId = (hour, weekday) -> weekday + hour.replace(/:/, '')

    $scope.pad = (minutes) ->
      if (minutes < 10)
        return "0" + minutes
      else
        return minutes

    return
  ]