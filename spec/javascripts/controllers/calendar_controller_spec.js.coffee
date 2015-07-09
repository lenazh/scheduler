describe "calendarCtrl", ->
  $scope = {}
  $controller = {}
  calendar = {}

  beforeEach ->
    fakeEvents = []

    factoryMock = {
      all: () -> fakeResults,
      saveNew: (name) -> {name: "New course", user_id: "1"},
      update: (course, name) -> {name: "Physics 8A", user_id: "1"},
      remove: (course) -> null
    }

  beforeEach ->  
    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'saveNew').and.callThrough()
    spyOn(factoryMock, 'update').and.callThrough()
    spyOn(factoryMock, 'remove')

    module "schedulerApp", ($provide) ->
      $provide.value 'Section', factoryMock
      return

    inject (_$controller_) ->
      $controller = _$controller_

    calendar = $controller 'calendarCtrl', {$scope: $scope}


  it "initializes $scope.weekdays"
  it "initializes $scope.hours"
  it 'calls Section.all() while initializing'
  it "initializes $scope.cells correctly with the section data"
  it "sets CSS attributes 'top' and 'height' correctly"


  describe 'calendar.updateSection', ->
    describe 'updating the weekday', ->
      it "when the section initially has one weekday and it changes, the section is moved into the appropriate cell"
      it "when the section initially has one weekday and the second one added, the section is linked to both cells"
      it "when the section initially has two weekdays and one is removed the section is linked to the appropriate cell"
      it "when the section has an invalid weekday it is displayed as invalid"
    describe 'updating the size'
      it "when start time changes the CSS updates correctly"
      it "when end time changes the CSS updates correctly"
      it "when start time is before end time the section is displayed as invalid"

    it 'sets the name of the event correctly'
    it 'calls the Section factory with correct parameters'

  describe "calendar.deleteSection", ->
    it "deletes the event from all the cells"
    it 'calls the Section factory with correct parameters'
  
  describe "$scope.newSection(hour, weekday)", ->
    it 'calls the Section factory with correct parameters'

  describe "$scope.getSections(hour, weekday)", ->
    it 'returns the content of a correct cell'


# Some fake data to get a feeling of how direcrives interact
# with each other and services before doing the proper coding

  # (cells[getKey('12:00pm', 'Monday')]).push {
  #   name: "Do some work",
  #   start: "12:15pm",
  #   end: "2pm",
  #   room: "275 Birge",
  #   style: {top: '25%', height: '175%'}
  # }

  # (cells[getKey('12:00pm', 'Monday')]).push {
  #   name: "Do more work",
  #   start: "12:00pm",
  #   end: "2pm",
  #   room: "275 Birge",
  #   style: {top: '0%', height: '200%'}
  # }

  # (cells[getKey('12:00pm', 'Monday')]).push {
  #   name: "Do even more work",
  #   start: "12:15pm",
  #   end: "1pm",
  #   room: "275 Birge",
  #   style: {top: '25%', height: '75%'}
  # }

  # (cells[getKey('6:00pm', 'Monday')]).push {
  #   name: "Go home",
  #   start: "6:00pm",
  #   end: "7:30pm",
  #   room: "none",
  #   style: {top: '0%', height: '150%'}
  # }

  # (cells[getKey('2:00pm', 'Tuesday')]).push {
  #   name: "Eat food",
  #   start: "2:30pm",
  #   end: "3:00pm",
  #   room: "home",
  #   style: {top: '50%', height: '50%'}
  # }

  # (cells[getKey('7:00pm', 'Friday')]).push {
  #   name: "Walk a dog",
  #   start: "7:00pm",
  #   end: "8:00pm",
  #   room: "(outside)",
  #   style: {top: '0%', height: '200%'}
  # }
