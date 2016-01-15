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
#   .gsisWithNoPreferences() returns the list of gsis that can teach less
#     classes than their appoinment requires them to
#   .needHours() returns how many hours/week are needed to teach all
#     the sections
#   .maxHours() returns how many hours/week the GSIs provide combined

class AutoScheduler
  # "private" methods and fields
  _sections: []
  _status: ['Not initialized']
  _GSIs: {}
  _solvable: false

  # Average satisfaction level of GSIs, calculated as
  # (gsi1.preference + gsi2.preference + ...)/count(gsi)
  _quality: 0.0

  # converts hours/week into maximum number of sections the GSI can teach
  hours_to_sections: (hours) -> @_GSIs.hours_to_sections(hours)

  # converts the number of sections into the hours/week required
  sections_to_hours: (sections) -> @_GSIs.sections_to_hours(sections)

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

  # performs basic checks of the system before running the solver
  _checkIfSolvable: ->
    @_solvable = (@sectionsNobodyCanTeach().length == 0) &&
      @enoughGsiHours()

  # public methods and fields

  constructor: (sections, gsis) ->
    @_sections = angular.copy sections
    @_GSIs = new schedulerApp.GSIs(gsis)
    @_solver = new schedulerApp.GreedySolver(sections, @_GSIs)
    @_checkIfSolvable()
    @_updateStatus()

  # getter/setter for keepWithinTheSameLecture
  keepWithinTheSameLecture: (value) ->
    if typeof value == 'undefined'
      return @_GSIs.keepWithinTheSameLecture
    @_GSIs.keepWithinTheSameLecture = value

  # returns a description of a problem if one exists or that
  # the solver is ready
  status: -> @_status

  # returns the result of the preliminary check of whether
  # a solution exists
  solvable: -> @_solvable

  # how many hours/week you need to teach all the sections
  needHours: -> @sections_to_hours @_sections.length

  # how many hours/week all the enrolled GSIs can teash
  maxHours: ->
    hours = 0
    for gsi in @_GSIs.all()
      hours += gsi.hours_per_week
    hours

  # brings the AutoScheduler to the initial state
  reset: -> @_solver.reset()

  # Check whether the total hours the GSIs can teach is more or
  # equal to the total hours required to teach the classes
  enoughGsiHours: ->
    @needHours() <= @maxHours()

  # Check the list of sections that no GSI can teach
  sectionsNobodyCanTeach: ->
    (section for section in @_sections when section['available_gsis'].length == 0)

  # Returns the list of unemployed GSIs and how many more hours/week
  # they can teach
  unemployed: ->
    unemployedGsiList = (gsi for gsi in @_GSIs.all() when @_GSIs.availability(gsi) > 0)
    for gsi in unemployedGsiList
      gsi['unused_hours'] = @sections_to_hours @_GSIs.availability(gsi)
    unemployedGsiList

  # Returns the list of the GSIs who can make fewer sections than their
  # appointment requires
  gsisWithNoPreferences: ->
    (gsi for gsi in @_GSIs.all() when @hours_to_sections(gsi.hours_per_week) > gsi.sections_can_teach)

  # returns how happy are the GSIs with their assignments on average
  quality: ->
    return 0.0 unless @solvable()
    @_solver.quality()

  # returns first available solution or null if none exists
  first: ->
    return null unless @solvable()
    @_solver.first()

  # returns next available solution or null if none exists
  next: ->
    return null unless @solvable()
    @_solver.next()

  # returns the previous solution or null if none exists
  previous: ->
    return null unless @solvable()
    @_solver.previous()

  # returns the current selected solution or null if no solution
  solution: ->
    return null unless @solvable()
    @_solver.solution()

  # returns the current selected solution adapted for testing
  # or null if no solution
  testSolution: ->
    return null unless @solvable()
    @_solver.testSolution()

  # 1 minute = 60 seconds
  # 1 hour = 3600 seconds
  # 1 day = 86400
  # 1 week = 604800
  # 1 month = 18144000
  # 1 year = 217728000

  toDecimals = (value) ->
    return Math.round(value * 10) / 10

  worstCase: ->
    time = 1
    for section in @_sections
      time *= section['available_gsis'].length
      break if time > 604800 * 1e6
    time /= 1e6
    if (time > 604800)
      return "over a week"
    if (time > 86400)
      return toDecimals(time / 86400) + " days"
    if (time > 3600)
      return toDecimals(time / 3600) + " hours"
    if (time > 60)
      return toDecimals(time / 60) + " minutes"
    return toDecimals(time) + " seconds"

schedulerApp.AutoScheduler = AutoScheduler