class AutoScheduler
  # "private" methods and fields
  _sections: []
  _gsis: []
  _status: ['Not initialized']
  _solvable: false
  _sectionsAvailable: {}

  # Sets correspondence between the sections and GSIs, such as
  # { section1 => gsi1, section2 => gsi2, ... }
  _solution: null

  # Average satisfaction level of GSIs, calculated as
  # (gsi1.preference + gsi2.preference + ...)/count(gsi) 
  _quality: 0

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections = (hours) ->
    hours / 10

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10

  # returns how many more sections the GSI can teach
  _availability: (gsi) ->
    @_sectionsAvailable[gsi.id]

  # changes the availability of the gsi by x
  _changeAvailability: (gsi, x) ->
    @_sectionsAvailable[gsi.id] += x

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
      if @_canTeach(gsi)
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
    availability = @_sectionsAvailable[gsi.id]
    if @_availability(gsi) > 0
      @_changeAvailability(gsi, -1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    section.lastGsi = gsi
    section.lastGsiIndex = index

  # marks that the GSI is no longer teaching the section
  _unassign: (gsi, section) ->
    section.lastGsi = null
    if @_availability(gsi) < hours_to_sections(gsi['hours_per_week'])
      @_changeAvailability(gsi, +1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was being returned more work hours \
      than he/she initially had"

  # returns true if the GSI can teach and false otherwise
  _canTeach: (gsi) ->
    @_sectionsAvailable[gsi.id] > 0
    
  # remember last GSI position for each section
  # and how much each GSI can teach
  _resetIndex: ->
    for section in @_sections
      section.lastGsi = null
      section.lastGsiIndex = -1
    for gsi in @_gsis
      @_sectionsAvailable[gsi.id] = hours_to_sections gsi['hours_per_week']

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
    @_quality = 0
    for section in @_sections
      @_solution[section.id] = section.lastGsi
      @_quality += section.lastGsi.preference
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

  # public methods

  constructor: (sections, gsis, options = {}) ->
    @_sections = sections
    @_gsis = gsis
    @_resetIndex()
    @checkIfSolvable()
    @_updateStatus()

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
    orphanSections = []
    for section in @_sections
      orphanSections.push(section) if section['available_gsis'].length == 0
    orphanSections  

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