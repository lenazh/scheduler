# TODO: this class should be split into multiple classes
# This class is responsible for automatic scheduling of classess
# AutoScheduler in constructed as
# scheduler = new AutoScheduler(sections, gsis)
#
# where
# sections is an array of sections to be scheduled and 
# gsis is an array of all available gsis
#
# each section in sections is a hash. Each section has to have
#  available_gsis field that is an array of all available gsis
#  each gsi in gsis is a hash that has 'id' and 'hours_per_week'
#  fields matching those in gsis array
#
# Solution is provided in a form of hash with scheduler.solution() is called
# (more convenient for testing)
#   {
#     section1_id: { GSI assigned to section 1 },
#     section2_id: { GSI assigned to section 2 },
#     ...
#   }
#
# Alternatively, the solution can be accessed at scheduler._solutionArray
# (turned out to be more convenient for integrating with CalendarController)
# [ gsi1, gsi2, gsi3, ... ], where the GSIs position correspond to section's
# positions in sections array the AutoScheduler was constructed with.
#
#
# scheduler has the following public methods:
#   .solvable() true if a solution may be found and false otherwise
#     there is no guarantee the solution actually exists
#   .first() returns the first available solution of null if none exists
#   .next() returns the next available solution or null if none exists
#     Equivalent to .first() when it's called the first time
#   .previous() returns the previous solution or null if none exists
#   .current() returns the current solution of null if none exists
#   .quality() returns the averaged happiness (preference) of all GSIs
#     chosen to teach the sections or 0.0 if there are no solution
#   .sectionsNobodyCanTeach() returns the list of sections that have
#     available_gsi == []
#   .unemployed() returns an array of GSIs who can teach more sections.
#     Each GSI has 'unused_hours' field with how many more hours he/she
#     can teach
#   .needHours() returns how many hours/week are needed to teach all
#     the sections
#   .maxHours() returns how many hours/week the GSIs provide combined

class AutoScheduler
  # "private" methods and fields
  _sections: []
  _gsis: []
  _status: ['Not initialized']
  _solvable: false
  _gsiData: {}

  # Sets correspondence between the sections and GSIs, such as
  # { section1 => gsi1, section2 => gsi2, ... }
  _solution: {}
  _solutionArray: []

  # Average satisfaction level of GSIs, calculated as
  # (gsi1.preference + gsi2.preference + ...)/count(gsi) 
  _quality: 0.0

  # indicates whether the scheduler should assign GSIs sections only within
  # the same lecture
  _keepWithinTheSameLecture: true

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections = (hours) ->
    hours / 10

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10

  # returns what section the lecture belongs to
  section_to_lecture = (section) ->
    section.name.substring(0, 1)

  # returns how many more sections the GSI can teach
  _availability: (gsi) ->
    @_gsiData[gsi.id]['availability']

  # changes the availability of the gsi by x
  _changeAvailability: (gsi, x) ->
    @_gsiData[gsi.id]['availability'] += x

  # sets the availability of the gsi to x and resets lecture index
  _setAvailability: (gsi, x) ->
    @_gsiData[gsi.id] = {}
    @_gsiData[gsi.id]['availability'] = x
    @_gsiData[gsi.id]['lectures'] = {}

  # returns how many hours the GSI is teaching in lecture that
  # section belongs to
  _getHours: (gsi, section) ->
    lecture = section_to_lecture section
    if typeof(@_gsiData[gsi.id]['lectures'][lecture]) == 'undefined'
      @_gsiData[gsi.id]['lectures'][lecture] = 0
    @_gsiData[gsi.id]['lectures'][lecture]

  # changes how many hours a GSI is teathing within the lecture
  # that section belongs to by x
  _changeHours: (gsi, section, x) ->
    lecture = section_to_lecture section
    if typeof(@_gsiData[gsi.id]['lectures'][lecture]) == 'undefined'
      @_gsiData[gsi.id]['lectures'][lecture] = 0
    @_gsiData[gsi.id]['lectures'][lecture] += x

  # returns whether the GSI is teaching the lecture the section
  # belongs to
  _teachingLecture: (gsi, section) ->
    lecture = section_to_lecture section
    @_gsiData[gsi.id]['lectures'][lecture] > 0

  # returns whether the GSI is teaching any lectures the section
  # doesn't belong to
  _teachingAnyOtherLecture: (gsi, section) ->
    lecture = section_to_lecture section
    for otherLecture, hours of @_gsiData[gsi.id]['lectures']
      if lecture != otherLecture
        return true if hours > 0
    return false

  # returns the next available GSI given a section and the gsi
  _nextGsi: (section) ->
    start = section.lastGsiIndex + 1
    end = section.available_gsis.length - 1
    return null if start > end
    @_findGsi(section, start, end)

  # returns the previous available GSI given a section and the gsi
  _previousGsi: (section) ->
    start = section.lastGsiIndex - 1
    end = 0
    return null if start < end
    @_findGsi(section, start, end)

  # returns the text available GSI witin the given range
  # start and end are both included
  _findGsi: (section, start, end) ->
    max = section.available_gsis.length
    if (start < 0) || (start >= max)
      throw "start pointer is out of range"
    if (end < 0) || (end >= max)
      throw "end pointer is out of range"
    for i in [start..end]
      gsi = section.available_gsis[i]
      if @_canTeach(gsi, section)
        @_assign(gsi, section, i)
        return gsi
    null

  # returns the upcoming GSI given section and direction
  _advanceGsi: (section, next) ->
    gsi = section.lastGsi
    @_unassign(gsi, section) if gsi
    gsi =
      if next then @_nextGsi(section, section.lastGsi)
      else @_previousGsi(section, section.lastGsi)
    @_setIndexAfterLast(section, next) unless gsi
    gsi

  # Rewinds the section index to beyond the last available
  # GSI in 'next' diraction
  _setIndexAfterLast: (section, next) ->
    section.lastGsiIndex = if next then section.available_gsis.length else -1

  # Rewinds the section index to beyond the first available
  # GSI in 'next' diraction
  _setIndexBeforeFirst: (section, next) ->
    section.lastGsiIndex = if next then -1 else section.available_gsis.length

  # advances the search by one step forward or backward
  _advanceSearch: (next) ->
    index = @_sections.length - 1
    section = @_sections[index]
    return unless section.lastGsi
    section.lastGsi = @_advanceGsi(section, next)

  # sets the GSI of that section to the first (or last) possible GSI,
  # depending on direction
  _resetSection: (id, next) ->
    return if (id < 0) or (id >= @_sections.length)
    section = @_sections[id]
    gsi = section.lastGsi
    @_unassign(gsi, section) if gsi
    @_setIndexBeforeFirst(section, next)

  # recursively assigns GSIs to sections with index id and larger
  # returns true if the assignment can be made and false otherwise
  _fill: (id, next, increment) ->
    return true if (id >= @_sections.length) || (id < 0)
    section = @_sections[id]
    gsi = section.lastGsi
    loop
      if gsi && @_fill(id + increment, next, increment)
        return true
      else
        gsi = @_advanceGsi(section, next)
        @_resetSection(id + increment, next)
        return false unless gsi

  # fills sections from "left" to "right"
  _fillRight: (next) =>
    @_fill(0, next, 1)

  # fills sections from "right" to "left"
  _fillLeft: (next) =>
    @_fill(@_sections.length - 1, next, -1)

  # marks that the GSI teaching the section
  _assign: (gsi, section, index) ->
    if @_availability(gsi) > 0
      @_changeAvailability(gsi, -1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    section.lastGsi = gsi
    section.lastGsiIndex = index
    @_changeHours(gsi, section, 1) if @_keepWithinTheSameLecture

  # marks that the GSI is no longer teaching the section
  _unassign: (gsi, section) ->
    section.lastGsi = null
    if @_availability(gsi) < hours_to_sections(gsi['hours_per_week'])
      @_changeAvailability(gsi, +1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was being returned more work hours \
      than he/she initially had"
    @_changeHours(gsi, section, -1) if @_keepWithinTheSameLecture

  # returns true if the GSI can teach and false otherwise
  _canTeach: (gsi, section) ->
    if @_keepWithinTheSameLecture
      (@_availability(gsi) > 0) && !@_teachingAnyOtherLecture(gsi, section)
    else
      @_availability(gsi) > 0
    
  # remember last GSI position for each section
  # and how much each GSI can teach
  _resetIndex: ->
    for section in @_sections
      section.lastGsi = null
      section.lastGsiIndex = -1
    for gsi in @_gsis
      @_setAvailability gsi, hours_to_sections(gsi['hours_per_week'])

  # updates the status of the solver
  _updateStatus: ->
    @_status = []
    if @sectionsNobodyCanTeach().length > 0
      @_status.push 'There are sections nobody can teach'

    unless @enoughGsiHours()
      @_status.push 'There are not enough GSIs to teach all the sections'
      @_status.push "You need #{@needHours() - @maxHours()} more hours/week"

    if @solvable()
      @_status.push 'Ready to schedule'

  _buildSolution: ->
    @_solution = {}
    @_solutionArray = new Array(@_sections.length)
    @_quality = 0
    for section, index in @_sections
      @_solution[section.id] = section.lastGsi
      @_solutionArray[index] = section.lastGsi
      @_quality += parseFloat(section.lastGsi.preference)
    @_quality /= @_sections.length
    return

  # finds the solution given the solver function and direction
  _solve: (solver, next) ->
    return null unless @solvable()
    if solver(next)
      @_buildSolution()
    else
      @_solution = null
      @_quality = 0
    @_solution  

  # public methods and fields

  constructor: (sections, gsis) ->
    @_sections = angular.copy sections
    @_gsis = angular.copy gsis
    @_resetIndex()
    @checkIfSolvable()
    @_updateStatus()

  # getter/setter for _keepWithinTheSameLecture
  keepWithinTheSameLecture: (value) ->
    return @_keepWithinTheSameLecture if typeof value == 'undefined'
    @_keepWithinTheSameLecture = value

  # returns a description of a problem if one exists or that
  # the solver is ready
  status: -> @_status

  # returns the result of the preliminary check of whether
  # a solution exists
  solvable: -> @_solvable

  # how many hours/week you need to teach all the sections
  needHours: ->
    sections_to_hours @_sections.length

  # how many hours/week all the enrolled GSIs can teash
  maxHours: ->
    hours = 0
    for gsi in @_gsis
      hours += gsi.hours_per_week
    hours

  # performs basic checks of the system
  checkIfSolvable: ->
    @_solvable = (@sectionsNobodyCanTeach().length == 0) && @enoughGsiHours()

  # Check whether the total hours the GSIs can teach is more or
  # equal to the total hours required to teach the classes
  enoughGsiHours: ->
    @needHours() <= @maxHours()

  # Check the list of sections that no GSI can teach
  sectionsNobodyCanTeach: ->
    (section for section in @_sections when section['available_gsis'].length == 0)

  # returns first available solution or null if none exists
  first: ->
    @_resetIndex()
    @_solve(@_fillRight, true)

  # returns next available solution or null if none exists
  next: ->
    @_advanceSearch(true)
    @_solve(@_fillRight, true)

  # returns the previous solution or null if none exists
  previous: ->
    @_advanceSearch(false)
    @_solve(@_fillRight, false)

  # returns the current selected solution or null if no solution
  current: ->
    return null unless @solvable
    @_solution

  # Returns the list of unemployed GSIs and how many more hours/week
  # they can teach
  unemployed: ->
    unemployedGsiList = (gsi for gsi in @_gsis when @_availability(gsi) > 0)
    for gsi in unemployedGsiList
      gsi['unused_hours'] = sections_to_hours @_availability(gsi)
    unemployedGsiList

  # returns how happy are the GSIs with their assignments on average
  quality: -> @_quality

schedulerApp.AutoScheduler = AutoScheduler