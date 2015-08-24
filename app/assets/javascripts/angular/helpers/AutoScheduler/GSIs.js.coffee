# Contains information about sections the GSIs are teaching
# Checks whether a GSI can teach a sections

class GSIs
  # "private" methods and fields

  # stores the sections GSIs have been assigned to
  _gsiData: {}
  # stores the list of all GSIs
  _gsis: []

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections = (hours) ->
    hours / 10

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10

  # returns what section the lecture belongs to
  section_to_lecture = (section) ->
    section.name.trim().substring(0, 1)

  # changes the availability of the gsi by x
  _changeAvailability: (gsi, x) ->
    @_gsiData[gsi.id]['availability'] += x

  # sets the availability of the gsi to maximum and resets the lecture index
  _initializeGSI: (gsi) ->
    @_gsiData[gsi.id] = {}
    hours = gsi['hours_per_week']
    @_gsiData[gsi.id]['availability'] = @hours_to_sections hours
    @_gsiData[gsi.id]['lectures'] = {}

  # returns how many sections the GSI is teaching in lecture that
  # section belongs to
  _getSectionNumber: (gsi, section) ->
    lecture = section_to_lecture section
    if typeof(@_gsiData[gsi.id]['lectures'][lecture]) == 'undefined'
      @_gsiData[gsi.id]['lectures'][lecture] = 0
    @_gsiData[gsi.id]['lectures'][lecture]

  # changes how many sections a GSI is teaching within the lecture
  # that section belongs to by x
  _changeSectionNumber: (gsi, section, x) ->
    lecture = section_to_lecture section
    if typeof(@_gsiData[gsi.id]['lectures'][lecture]) == 'undefined'
      @_gsiData[gsi.id]['lectures'][lecture] = 0
    @_gsiData[gsi.id]['lectures'][lecture] += x
    sectionNumber = @_gsiData[gsi.id]['lectures'][lecture]
    if (sectionNumber < 0)
      throw "GSI #{gsi.id} #{gsi.name} is teaching negative number of \
      sections in lecture #{lecture} after being unassigned from section \
      #{section.name}"
    sectionNumber

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

  # marks all GSIs as free
  _initialize: -> reset()

  # public methods
  constructor: (gsis) ->
    @_gsis = angular.copy gsis
    @initialize()

  # indicates whether the scheduler should assign GSIs sections only within
  # the same lecture
  keepWithinTheSameLecture: true

  # marks that the GSI teaching the section
  assign: (gsi, section) ->
    if @_availability(gsi) > 0
      @_changeAvailability(gsi, -1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    @_changeSectionNumber(gsi, section, 1) if @keepWithinTheSameLecture()

  # marks that the GSI is no longer teaching the section
  unassign: (gsi, section) ->
    if @_availability(gsi) < hours_to_sections(gsi['hours_per_week'])
      @_changeAvailability(gsi, +1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was being returned more work hours \
      than he/she initially had"
    @_changeSectionNumber(gsi, section, -1) if @keepWithinTheSameLecture()

  # returns true if the GSI can teach and false otherwise
  canTeach: (gsi, section) ->
    if @keepWithinTheSameLecture
      (@_availability(gsi) > 0) && !@_teachingAnyOtherLecture(gsi, section)
    else
      @_availability(gsi) > 0

  # returns how many more sections the GSI can teach
  availability: (gsi) ->
    @_gsiData[gsi.id]['availability']

  # returns the list of all GSIs
  all: ->
    _gsis

  # marks all GSIs as free
  reset: ->
    for gsi in @_gsis
      @_initializeGSI gsi


schedulerApp.GSIs = GSIs