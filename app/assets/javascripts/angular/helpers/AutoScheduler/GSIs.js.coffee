# Contains information about sections the GSIs are teaching
# Checks whether a GSI can teach a sections

class GSIs
  # "private" methods and fields

  # stores the sections GSIs have been assigned to
  _gsiData: {}
  # stores the list of all GSIs
  _gsis: []

  # returns what section the lecture belongs to
  section_to_lecture = (section) ->
    section.name.substring(0, 1)

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


  # public methods

  constructor: (gsis) ->
    @_gsis = angular.copy gsis

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections = (hours) ->
    hours / 10

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10

  # indicates whether the scheduler should assign GSIs sections only within
  # the same lecture
  keepWithinTheSameLecture: true

  # marks that the GSI teaching the section
  assign: (gsi, section, index) ->
    if @_availability(gsi) > 0
      @_changeAvailability(gsi, -1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    section.lastGsi = gsi
    section.lastGsiIndex = index
    @_changeHours(gsi, section, 1) if @keepWithinTheSameLecture()

  # marks that the GSI is no longer teaching the section
  unassign: (gsi, section) ->
    section.lastGsi = null
    if @_availability(gsi) < hours_to_sections(gsi['hours_per_week'])
      @_changeAvailability(gsi, +1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was being returned more work hours \
      than he/she initially had"
    @_changeHours(gsi, section, -1) if @keepWithinTheSameLecture()

  # returns true if the GSI can teach and false otherwise
  canTeach: (gsi, section) ->
    if @keepWithinTheSameLecture
      (@_availability(gsi) > 0) && !@_teachingAnyOtherLecture(gsi, section)
    else
      @_availability(gsi) > 0

  # returns how many more sections the GSI can teach
  availability: (gsi) ->
    @_gsiData[gsi.id]['availability']

  all: ->
    _gsis

  reset: ->
    for gsi in @_gsis
      @_setAvailability gsi, hours_to_sections(gsi['hours_per_week'])


schedulerApp.GSIs = GSIs