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
  hours_to_sections: (hours) -> hours_to_sections(hours)

  # converts the number of sections into the hours/week required
  sections_to_hours = (sections) ->
    sections * 10
  sections_to_hours: (sections) -> sections_to_hours(sections)

  # returns what section the lecture belongs to
  section_to_lecture = (section) ->
    section.name.trim().substring(0, 1)
  section_to_lecture: (section) -> section_to_lecture(section)

  # changes the availability of the gsi by x
  _changeAvailability: (gsi, x) ->
    @_gsiData[gsi.id]['availability'] += x

  # sets the availability of the gsi to maximum and resets
  # lecture and section indexes
  _initializeGSI: (gsi) ->
    @_gsiData[gsi.id] = {}
    hours = gsi['hours_per_week']
    @_gsiData[gsi.id]['availability'] = hours_to_sections hours
    @_gsiData[gsi.id]['lectures'] = {}
    @_gsiData[gsi.id]['sections'] = {}

  # Adds the section to the list of sections taught by the gsi
  _addSection: (gsi, section) ->
    if @_gsiData[gsi.id]['sections'][section.id]
      throw "Trying to assign section '#{section.name}' to GSI \
      '#{gsi.name}' who already has this section assigned"
    @_gsiData[gsi.id]['sections'][section.id] = section

  # Removes the section to the list of sections taught by the gsi
  _removeSection: (gsi, section) ->
    if typeof(@_gsiData[gsi.id]['sections'][section.id]) == 'undefined'
      throw "Trying to unassign section '#{section.name}' to GSI \
      '#{gsi.name}' that was never assigned to him/her"
    delete @_gsiData[gsi.id]['sections'][section.id]

  # Returns the list of all the section this GSI has assigned
  _listSections: (gsi) -> @_gsiData[gsi.id]['sections']

  # Converts the section into an object that is easier to compare to
  _extractTime: (section) ->
    result = {}
    result.start = section['start_hour'] + section['start_minute'] / 60
    result.start = Math.round(result.start * 100) / 100
    result.end = result.start + section['duration_hours']
    result

  # returns true if there is a time overlap between the sections,
  # excluding the endpoints
  _sectionsOverlap: (existing, created) ->
    return true if existing.start <= created.start < existing.end
    return true if existing.start < created.end < existing.end
    return true if created.start <= existing.start < created.end
    return true if created.start < existing.end < created.end
    false

  # Returns true if newSection and existingSection have a time conflict
  # given newWeekday and existingWeekday
  _timeConflictSingleWeekday: (existing, created, existingWeekday, createdWeekday) ->
    return false unless existingWeekday == createdWeekday
    @_sectionsOverlap(@_extractTime(existing), @_extractTime(created))

  # Returns true if newSection and existingSection have a time conflict
  _timeConflictCheck: (existingSection, newSection) ->
    existingWeekdays = existingSection['weekday'].split(/[,; ]+/)
    newWeekdays = newSection['weekday'].split(/[,; ]+/)
    for existingWeekday in existingWeekdays
      for newWeekday in newWeekdays
        if @_timeConflictSingleWeekday(existingSection,
          newSection, existingWeekday.trim(), newWeekday.trim())
          return true
    return false

  # Returns true if assigning section to gsi would create a time conflict
  _createsTimeConflict: (gsi, newSection) ->
    for key, existingSection of @_listSections(gsi)
      return true if @_timeConflictCheck(existingSection, newSection)
    return false

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
  _initialize: -> @reset()

  # public methods
  constructor: (gsis) ->
    @_gsis = angular.copy gsis
    @_initialize()

  # indicates whether the scheduler should assign GSIs sections only within
  # the same lecture
  keepWithinTheSameLecture: true

  # marks that the GSI teaching the section
  assign: (gsi, section) ->
    if @availability(gsi) > 0
      @_changeAvailability(gsi, -1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was assigned above maximal workload"
    @_addSection(gsi, section)
    @_changeSectionNumber(gsi, section, 1) if @keepWithinTheSameLecture

  # marks that the GSI is no longer teaching the section
  unassign: (gsi, section) ->
    if @availability(gsi) < hours_to_sections(gsi['hours_per_week'])
      @_changeAvailability(gsi, +1)
    else
      throw "GSI #{gsi.id} #{gsi.name} was being returned more work hours \
      than he/she initially had"
    @_removeSection(gsi, section)
    @_changeSectionNumber(gsi, section, -1) if @keepWithinTheSameLecture

  # returns true if the GSI can teach and false otherwise
  canTeach: (gsi, section) ->
    return false if @_createsTimeConflict(gsi, section)
    if @keepWithinTheSameLecture
      (@availability(gsi) > 0) && !@_teachingAnyOtherLecture(gsi, section)
    else
      @availability(gsi) > 0

  # returns how many more sections the GSI can teach
  availability: (gsi) ->
    @_gsiData[gsi.id]['availability']

  # returns the list of all GSIs
  all: ->
    @_gsis

  # marks all GSIs as free
  reset: ->
    for gsi in @_gsis
      @_initializeGSI gsi


schedulerApp.GSIs = GSIs