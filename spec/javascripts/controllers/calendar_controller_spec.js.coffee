describe "calendarCtrl", ->
  $scope = {}
  $controller = {}
  calendar = {}

  beforeEach ->
    fakeResults = [
      {
        "id": "1",
        "name": "101",
        "start_time" : "2015-06-09T10:15:00.000Z",
        "end_time" : "2015-06-09T12:00:00.000Z",
        "weekday" : "Monday, Wednesday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": "2",
        "name": "102",
        "start_time" : "2015-06-09T12:30:00.000Z",
        "end_time" : "2015-06-09T14:00:00.000Z",
        "weekday" : "Monday, Wednesday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": "3",
        "name": "103",
        "start_time" : "2015-06-09T10:00:00.000Z",
        "end_time" : "2015-06-09T12:00:00.000Z",
        "weekday" : "Monday, Wednesday",
        "room" : "106",
        "gsi" : {}
      },
      {
        "id": "4",
        "name": "104",
        "start_time" : "2015-06-09T12:00:00.000Z",
        "end_time" : "2015-06-09T14:00:00.000Z",
        "weekday" : "Tuesday, Thursday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": "5",
        "name": "106",
        "start_time" : "2015-06-09T16:00:00.000Z",
        "end_time" : "2015-06-09T17:00:00.000Z",
        "weekday" : "Friday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": "6",
        "name": "107",
        "start_time" : "2015-06-09T14:00:00.000Z",
        "end_time" : "2015-06-09T16:30:00.000Z",
        "weekday" : "Tuesday, Thursday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": "7",
        "name": "108",
        "start_time" : "2015-06-09T16:00:00.000Z",
        "end_time" : "2015-06-09T17:30:00.000Z",
        "weekday" : "Thursday",
        "room" : "105",
        "gsi" : {}
      }
    ]

    factoryMock = {
      all: () -> fakeResults,
      saveNew: (name) -> null,
      update: (course, name) -> null,
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


  it "initializes $scope.weekdays", ->
    expect($scope.weekdays).toBeDefined()
    expect($scope.weekdays).toBe(Jasmine.any(Array))

  it "initializes $scope.hours", ->
    expect($scope.hours).toBeDefined()
    expect($scope.hours).toBe(Jasmine.any(Array))

  it 'calls Section.all() while initializing', ->
    expect(factoryMock.all).toHaveBeenCalled()

  it "initializes $scope.cells correctly with the section data", ->
    expect($scope.getSections('10:00am', 'Monday')[0]['id']).toEqual "1"
    expect($scope.getSections('10:00am', 'Wednesday')[0]['id']).toEqual "1"
    expect($scope.getSections('12:00am', 'Monday')[0]['id']).toEqual "2"
    expect($scope.getSections('12:00am', 'Wednesday')[0]['id']).toEqual "2"
    expect($scope.getSections('10:00am', 'Monday')[1]['id']).toEqual "3"
    expect($scope.getSections('10:00am', 'Wednesday')[1]['id']).toEqual "3"
    expect($scope.getSections('12:00pm', 'Tuesday')[0]['id']).toEqual "4"
    expect($scope.getSections('12:00pm', 'Thursday')[0]['id']).toEqual "4"
    expect($scope.getSections('4:00pm', 'Friday')[0]['id']).toEqual "5"
    expect($scope.getSections('2:00pm', 'Tuesday')[0]['id']).toEqual "6"
    expect($scope.getSections('2:00pm', 'Thursday')[0]['id']).toEqual "6"
    expect($scope.getSections('4:00pm', 'Thursday')[0]['id']).toEqual "7"

  it "sets CSS attributes 'top' and 'height' correctly", ->
    expect($scope.getSections('10:00am', 'Monday')[0]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00am', 'Monday')[0]['style']['height']).toEqual "175%"
    expect($scope.getSections('10:00am', 'Wednesday')[0]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00am', 'Wednesday')[0]['style']['height']).toEqual "175%"
    expect($scope.getSections('12:00am', 'Monday')[0]['style']['top']).toEqual "50%" 
    expect($scope.getSections('12:00am', 'Monday')[0]['style']['height']).toEqual "150%"
    expect($scope.getSections('12:00am', 'Wednesday')[0]['style']['top']).toEqual "50%"
    expect($scope.getSections('12:00am', 'Wednesday')[0]['style']['height']).toEqual "150%"
    expect($scope.getSections('10:00am', 'Monday')[1]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00am', 'Monday')[1]['style']['height']).toEqual "200%"
    expect($scope.getSections('10:00am', 'Wednesday')[1]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00am', 'Wednesday')[1]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00pm', 'Tuesday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00pm', 'Tuesday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00pm', 'Thursday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00pm', 'Thursday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('4:00pm', 'Friday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('4:00pm', 'Friday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('2:00pm', 'Tuesday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('2:00pm', 'Tuesday')[0]['style']['height']).toEqual "250%" 
    expect($scope.getSections('2:00pm', 'Thursday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('2:00pm', 'Thursday')[0]['style']['height']).toEqual "250%" 
    expect($scope.getSections('4:00pm', 'Thursday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('4:00pm', 'Thursday')[0]['style']['height']).toEqual "150%" 

  it "recognizes the mock sections as valid", ->
    expect($scope.getSections('10:00am', 'Monday')[0]['isValid']).toBe true
    expect($scope.getSections('10:00am', 'Wednesday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00am', 'Monday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00am', 'Wednesday')[0]['isValid']).toBe true
    expect($scope.getSections('10:00am', 'Monday')[1]['isValid']).toBe true
    expect($scope.getSections('10:00am', 'Wednesday')[1]['isValid']).toBe true
    expect($scope.getSections('12:00pm', 'Tuesday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00pm', 'Thursday')[0]['isValid']).toBe true
    expect($scope.getSections('4:00pm', 'Friday')[0]['isValid']).toBe true
    expect($scope.getSections('2:00pm', 'Tuesday')[0]['isValid']).toBe true
    expect($scope.getSections('2:00pm', 'Thursday')[0]['isValid']).toBe true
    expect($scope.getSections('4:00pm', 'Thursday')[0]['isValid']).toBe true

  describe 'calendar.updateSection', ->
    describe 'updating the weekday', ->
      it 'calls the Section factory with correct parameters', ->
        section = $scope.getSections('4:00pm', 'Friday')[0]
        section['weekday'] = "Monday"
        calendar.updateSection section
        expect(factoryMock.update).toHaveBeenCalledWith section

      describe 'section with a single weekday', ->
        it "when the weekday changes, the section is moved into the appropriate cell", ->
          section = $scope.getSections('4:00pm', 'Friday')[0]
          id = section['id']
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('4:00pm', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('4:00pm', 'Friday').length).toEqual 0

        it "when another section is modified to have the same weekday it is appended to the cell", ->
          section = $scope.getSections('4:00pm', 'Thursday')[0]
          id = section['id']
          section['weekday'] = "Thursday, Friday"
          calendar.updateSection section
          expect($scope.getSections('4:00pm', 'Friday')[1]['id']).toEqual id

        it "the section is given a second weekday, it remains
          in the original cell and is appended to the new cell", ->
          section = $scope.getSections('4:00pm', 'Friday')[0]
          id = section['id']
          section['weekday'] = "Friday, Monday"
          calendar.updateSection section
          expect($scope.getSections('4:00pm', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('4:00pm', 'Friday')[0]['id']).toEqual id

      describe 'section with two weekdays', ->
        it "when one weekday is removed the cells update accordingly", ->
          section = $scope.getSections('12:00pm', 'Monday')[0]
          id = section['id']
          expect($scope.getSections('12:00pm', 'Wednesday')[0]['id']).toEqual id
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('12:00pm', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('12:00pm', 'Wednesday').length).toEqual 0

        it "when the third weekday is added to an empty cell, the cells update accordingly", ->
          section = $scope.getSections('12:00pm', 'Monday')[0]
          id = section['id']
          expect($scope.getSections('12:00pm', 'Wednesday')[0]['id']).toEqual id
          section['weekday'] = "Monday, Wednesday, Friday"
          calendar.updateSection section
          expect($scope.getSections('12:00pm', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('12:00pm', 'Wednesday')[0]['id']).toEqual id
          expect($scope.getSections('12:00pm', 'Friday')[0]['id']).toEqual id
      
      it "when the section has an invalid weekday it is displayed as invalid", ->
        section = $scope.getSections('4:00pm', 'Friday')[0]
        section["weekday"] = "Kittens"
        calendar.updateSection section
        expect($scope.getSections('4:00pm', 'Friday')[0]['isValid']).toBe false

    describe 'updating the size', ->
      it "when start time changes the CSS updates correctly", ->
        section = $scope.getSections('4:00pm', 'Friday')[0]
        section['start_time'] = "4:30pm"
        calendar.update section
        expect($scope.getSections('4:00pm', 'Friday')[0]['style']['top']).toEqual '50%'
        expect($scope.getSections('4:00pm', 'Friday')[0]['style']['height']).toEqual '50%'

      it "when end time changes the CSS updates correctly"
      it "when start time is before end time the section is displayed as invalid"
      it 'calls the Section factory with correct parameters'

    it 'sets the name of the event correctly'
    

  describe "calendar.deleteSection", ->
    it "deletes the event from all the cells"
    it 'calls the Section factory with correct parameters'
  
  describe "$scope.newSection(hour, weekday)", ->
    it 'calls the Section factory with correct parameters'

  describe "$scope.getSections(hour, weekday)", ->
    it 'is defined', ->
      expect($scope.getSections).toBeDefined()
      expect($scope.weekdays).toBe(Jasmine.any(Function))


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
