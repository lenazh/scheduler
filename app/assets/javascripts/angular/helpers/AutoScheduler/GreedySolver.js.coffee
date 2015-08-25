# Finds the possible GSI assignments
class GreedySolver
  _sections: []
  _GSIs: {}

  # Sets correspondence between the sections and GSIs, such as
  # { section1 => gsi1, section2 => gsi2, ... }
  _testSolution: {}
  _solution: []

  # Average satisfaction level of GSIs, calculated as
  # (gsi1.preference + gsi2.preference + ...)/count(gsi) 
  _quality: 0.0

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections: (hours) -> @_GSIs.hours_to_sections(hours)

  # converts the number of sections into the hours/week required
  sections_to_hours: (sections) -> @_GSIs.sections_to_hours(sections)

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
      if @_GSIs.canTeach(gsi, section)
        @_assign(gsi, section, i)
        return gsi
    null

  # Rewinds the section index to beyond the last available
  # GSI in 'next' direction
  _setIndexAfterLast: (section, next) ->
    section.lastGsiIndex = if next then section.available_gsis.length else -1

  # Rewinds the section index to beyond the first available
  # GSI in 'next' direction
  _setIndexBeforeFirst: (section, next) ->
    section.lastGsiIndex = if next then -1 else section.available_gsis.length

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

  # returns the solution given the solver function and direction
  _solve: (solverFunction, next) ->
    if solverFunction(next)
      @_buildSolution()
    else
      @_testSolution = null
      @_solution = []
      @_quality = 0.0
    @_solution

  _buildSolution: ->
    @_testSolution = {}
    @_solution = new Array(@_sections.length)
    @_quality = 0.0
    for section, index in @_sections
      @_testSolution[section.id] = section.lastGsi
      @_solution[index] = section.lastGsi
      @_quality += parseFloat(section.lastGsi.preference)
    @_quality /= @_sections.length
    return

  # assigns last GSI index
  _assignSection: (section, gsi, index) ->
    section.lastGsi = gsi
    section.lastGsiIndex = index 

  # resets last GSI index to the beginning
  _resetSectionIndex: (section) ->   
    section.lastGsi = null
    section.lastGsiIndex = -1

  # resets every section
  _initialize: -> @_resetAllSections()
  _resetAllSections: ->
    for section in @_sections
      @_resetSectionIndex(section)

  # marks that the GSI teaching the section
  _assign: (gsi, section, index) ->
    @_assignSection(section, gsi, index)
    @_GSIs.assign(gsi, section)

  # marks that the GSI is no longer teaching the section
  _unassign: (gsi, section) ->
    section.lastGsi = null
    @_GSIs.unassign(gsi, section)

  # returns the upcoming GSI given section and direction
  _advanceGsi: (section, next) ->
    gsi = section.lastGsi
    @_unassign(gsi, section) if gsi
    gsi =
      if next then @_nextGsi(section, gsi)
      else @_previousGsi(section, gsi)
    @_setIndexAfterLast(section, next) unless gsi
    gsi

  # advances the search by one step forward or backward
  _advanceSearch: (next) ->
    index = @_sections.length - 1
    section = @_sections[index]
    return unless section.lastGsi
    section.lastGsi = @_advanceGsi(section, next)

  # "public" methods
  constructor: (sections, GSIs) ->
    @_sections = angular.copy sections
    @_GSIs = GSIs
    @_initialize()

  # resets the solver to the initial state
  reset: ->
    @_resetAllSections()
    @_GSIs.reset()

  # returns first available solution or null if none exists
  first: ->
    @reset()
    @_solve(@_fillRight, true)

  # returns next available solution or null if none exists
  next: ->
    @_advanceSearch(true)
    @_solve(@_fillRight, true)

  # returns the previous solution or null if none exists
  previous: ->
    @_advanceSearch(false)
    @_solve(@_fillRight, false)

  # returns the latest found solution
  solution: -> @_solution

  # returns the quality of the latest solution
  quality: ->  @_quality

  # returns the latest found solution adapted for testing
  testSolution: -> @_testSolution

schedulerApp.GreedySolver = GreedySolver