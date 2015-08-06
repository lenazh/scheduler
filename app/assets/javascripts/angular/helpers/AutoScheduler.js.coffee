class AutoScheduler
  # "private" methods and fields
  _sections: []
  _gsis: []
  _status: ['Not initialized']
  _solvable: false
  _sectionsAvailable: {}

  # Sets correspondence between the sections and GSIs, such as
  # { section1 => gsi1, section2 => gsi2, ... }
  _solution: {}

  # Average satisfaction level of GSIs, calculated as
  # (gsi1.preference + gsi2.preference + ...)/count(gsi) 
  _quality: 0

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections = (hours) ->
    hours / 10

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10

  # returns true if the GSI can teach and false otherwise
  _canTeach: (gsi) ->
    @_sectionsAvailable[gsi.id] > 0

  # returns the next available GSI given a section and the gsi
  _nextGsi: (section) ->
    gsi = section.lastGsi
    start = section.lastGsiIndex + 1
    end = section.available_gsis.length - 1
    @_unassign(gsi, section) if gsi
    return null if start > end
    @_findGsi(section, start, end)

  # returns the previous available GSI given a section and the gsi
  _previousGsi: (section) ->
    gsi = section.lastGsi
    start = section.lastGsiIndex - 1
    end = 0
    @_unassign(gsi, section) if gsi
    return null if start < end
    @_findGsi(section, start, end)

  # returns the text available GSI witin the given range
  # start and end are both included
  _findGsi: (section, start, end) ->
    for i in [start..end]
      gsi = section.available_gsis[i]
      if @_canTeach(gsi)
        @_assign(gsi, section, i)
        return gsi
    null

  # recursively assigns GSIs to sections with index id and larger
  # returns true if the assignment can be made and false otherwise
  _fill: (id) ->
    return true if id >= @_sections.length
    loop
      section = @_sections[id]
      gsi = @_nextGsi(section, section.lastGsi)
      return false unless gsi
      section.lastGsi = gsi
      return true if fill(id + 1)

  # marks that the GSI teaching the section
  _assign: (gsi, section, index) ->
    availability = @_sectionsAvailable[gsi.id]
    if availability > 0
      @_sectionsAvailable[gsi.id] -= 1
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    section.lastGsi = gsi
    section.lastGsiIndex = index

  # marks that the GSI is no longer teaching the section
  _unassign: (gsi, section) ->
    availability = @_sectionsAvailable[gsi.id]
    if availability < hours_to_sections(gsi['hours_per_week'])
      @_sectionsAvailable[gsi.id] += 1
    else
      throw "GSI #{gsi.id} #{gsi.name} recovered more hours than he/she \
      initially had"

  # remember last GSI position for each section
  _prepareSectionIndex: ->
    for section in @_sections
      section.lastGsi = null
      section.lastGsiIndex = -1

  # appends how many sections a GSI can teach to each GSI
  _prepareGsiIndex: ->
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

    if @solvable
      @_status.push 'Ready to schedule'

  # public methods

  constructor: (sections, gsis, options = {}) ->
    @_sections = sections
    @_gsis = gsis
    @checkIfSolvable()
    @_updateStatus()
    if @solvable()
      @_prepareGsiIndex()
      @_prepareSectionIndex()


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

  # returns next available solution or null if none exists
  next: ->
    return unless @solvable
    null

  # returns the previous solution or null if none exists
  previous: ->
    return unless @solvable
    null

  # returns the current selected solution or null if no solution
  current: ->
    return unless @solvable
    null

  # Returns the list of unemployed GSIs and how many more hours/week
  # they can teach
  unemployed: ->
    null

  # returns how happy are the GSIs with their assignments on average
  quality: -> @_quality


schedulerApp.AutoScheduler = AutoScheduler