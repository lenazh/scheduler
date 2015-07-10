describe "calendarCtrl", ->
  $scope = {}
  $controller = {}
  calendar = {}
  factoryMock = {}
  fakeResults = {}

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
      all: (callback) -> 
        callback(fakeResults)
        fakeResults
      ,
      saveNew: (name) -> null,
      update: (course, name) -> null,
      remove: (course) -> null
    }

    spyOn(factoryMock, 'all').and.callThrough()
    spyOn(factoryMock, 'saveNew').and.callThrough()
    spyOn(factoryMock, 'update').and.callThrough()
    spyOn(factoryMock, 'remove').and.callThrough()

    module "schedulerApp", ($provide) ->
      $provide.value 'Section', factoryMock
      return

    inject (_$controller_) ->
      $controller = _$controller_

    calendar = $controller 'calendarCtrl', {$scope: $scope}


  it "initializes $scope.weekdays", ->
    expect($scope.weekdays).toBeDefined()
    expect($scope.weekdays.length).toBeGreaterThan 0

  it "initializes $scope.hours", ->
    expect($scope.hours).toBeDefined()
    expect($scope.hours.length).toBeGreaterThan 0

  it 'calls Section.all() while initializing', ->
    expect(factoryMock.all).toHaveBeenCalled()

  it "initializes $scope.cells correctly with the section data", ->
    expect($scope.getSections('10:00', 'Monday')[0]['id']).toEqual "1"
    expect($scope.getSections('10:00', 'Wednesday')[0]['id']).toEqual "1"
    expect($scope.getSections('12:00', 'Monday')[0]['id']).toEqual "2"
    expect($scope.getSections('12:00', 'Wednesday')[0]['id']).toEqual "2"
    expect($scope.getSections('10:00', 'Monday')[1]['id']).toEqual "3"
    expect($scope.getSections('10:00', 'Wednesday')[1]['id']).toEqual "3"
    expect($scope.getSections('12:00', 'Tuesday')[0]['id']).toEqual "4"
    expect($scope.getSections('12:00', 'Thursday')[0]['id']).toEqual "4"
    expect($scope.getSections('16:00', 'Friday')[0]['id']).toEqual "5"
    expect($scope.getSections('14:00', 'Tuesday')[0]['id']).toEqual "6"
    expect($scope.getSections('14:00', 'Thursday')[0]['id']).toEqual "6"
    expect($scope.getSections('16:00', 'Thursday')[0]['id']).toEqual "7"

  it "sets CSS attributes 'top' and 'height' correctly", ->
    expect($scope.getSections('10:00', 'Monday')[0]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00', 'Monday')[0]['style']['height']).toEqual "175%"
    expect($scope.getSections('10:00', 'Wednesday')[0]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00', 'Wednesday')[0]['style']['height']).toEqual "175%"
    expect($scope.getSections('12:00', 'Monday')[0]['style']['top']).toEqual "50%" 
    expect($scope.getSections('12:00', 'Monday')[0]['style']['height']).toEqual "150%"
    expect($scope.getSections('12:00', 'Wednesday')[0]['style']['top']).toEqual "50%"
    expect($scope.getSections('12:00', 'Wednesday')[0]['style']['height']).toEqual "150%"
    expect($scope.getSections('10:00', 'Monday')[1]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00', 'Monday')[1]['style']['height']).toEqual "200%"
    expect($scope.getSections('10:00', 'Wednesday')[1]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00', 'Wednesday')[1]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00', 'Tuesday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00', 'Tuesday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00', 'Thursday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00', 'Thursday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('16:00', 'Friday')[0]['style']['top']).toEqual "0%"
    expect($scope.getSections('16:00', 'Friday')[0]['style']['height']).toEqual "200%"
    expect($scope.getSections('14:00', 'Tuesday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('14:00', 'Tuesday')[0]['style']['height']).toEqual "250%" 
    expect($scope.getSections('14:00', 'Thursday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('14:00', 'Thursday')[0]['style']['height']).toEqual "250%" 
    expect($scope.getSections('16:00', 'Thursday')[0]['style']['top']).toEqual "0%" 
    expect($scope.getSections('16:00', 'Thursday')[0]['style']['height']).toEqual "150%" 

  it "mock sections are marked as valid", ->
    expect($scope.getSections('10:00', 'Monday')[0]['isValid']).toBe true
    expect($scope.getSections('10:00', 'Wednesday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00', 'Monday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00', 'Wednesday')[0]['isValid']).toBe true
    expect($scope.getSections('10:00', 'Monday')[1]['isValid']).toBe true
    expect($scope.getSections('10:00', 'Wednesday')[1]['isValid']).toBe true
    expect($scope.getSections('12:00', 'Tuesday')[0]['isValid']).toBe true
    expect($scope.getSections('12:00', 'Thursday')[0]['isValid']).toBe true
    expect($scope.getSections('16:00', 'Friday')[0]['isValid']).toBe true
    expect($scope.getSections('14:00', 'Tuesday')[0]['isValid']).toBe true
    expect($scope.getSections('14:00', 'Thursday')[0]['isValid']).toBe true
    expect($scope.getSections('16:00', 'Thursday')[0]['isValid']).toBe true

  describe 'calendar.updateSection', ->
    describe 'updating the weekday', ->
      it 'calls the Section factory with correct parameters', ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['weekday'] = "Monday"
        calendar.updateSection section
        expect(factoryMock.update).toHaveBeenCalledWith section


      describe 'section with a single weekday', ->
        it "when the weekday changes, the section is moved into the appropriate cell", ->
          section = $scope.getSections('16:00', 'Friday')[0]
          id = section['id']
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('16:00', 'Friday').length).toEqual 0

        it "when another section is modified to have the same weekday it is appended to the cell", ->
          section = $scope.getSections('16:00', 'Thursday')[0]
          id = section['id']
          section['weekday'] = "Thursday, Friday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[1]['id']).toEqual id

        it "the section is given a second weekday, it remains
          in the original cell and is appended to the new cell", ->
          section = $scope.getSections('16:00', 'Friday')[0]
          id = section['id']
          section['weekday'] = "Friday, Monday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('16:00', 'Friday')[0]['id']).toEqual id

        it 'updates the name correctly', ->
          section = $scope.getSections('16:00', 'Friday')[0]
          name = "Kitten Gathering"
          section['name'] = name
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[0]['name']).toEqual name

        it 'updates the room correctly', ->
          section = $scope.getSections('16:00', 'Friday')[0]
          room = "Cafe Strada"
          section['room'] = room
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[0]['room']).toEqual room


      describe 'section with two weekdays', ->
        it "when one weekday is removed the cells update accordingly", ->
          section = $scope.getSections('12:00', 'Monday')[0]
          id = section['id']
          expect($scope.getSections('12:00', 'Wednesday')[0]['id']).toEqual id
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('12:00', 'Wednesday').length).toEqual 0

        it "when the third weekday is added to an empty cell, the cells update accordingly", ->
          section = $scope.getSections('12:00', 'Monday')[0]
          id = section['id']
          expect($scope.getSections('12:00', 'Wednesday')[0]['id']).toEqual id
          section['weekday'] = "Monday, Wednesday, Friday"
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[0]['id']).toEqual id
          expect($scope.getSections('12:00', 'Wednesday')[0]['id']).toEqual id
          expect($scope.getSections('12:00', 'Friday')[0]['id']).toEqual id

        it 'updates the name correctly', ->
          section = $scope.getSections('12:00', 'Monday')[0]
          name = "Kitten Gathering"
          section['name'] = name
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[0]['name']).toEqual name
          expect($scope.getSections('12:00', 'Wednesday')[0]['name']).toEqual name

        it 'updates the room correctly', ->
          section = $scope.getSections('12:00', 'Monday')[0]
          room = "Cafe Strada"
          section['room'] = room
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[0]['room']).toEqual room
          expect($scope.getSections('12:00', 'Wednesday')[0]['room']).toEqual room
      

      it "when the section has an invalid weekday it is marked as invalid", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section["weekday"] = "Kittens"
        calendar.updateSection section
        expect($scope.getSections('16:00', 'Friday')[0]['isValid']).toBe false


    describe 'updating the size', ->
      it "updates the CSS correctly when start time changes", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['start_time'] = "14:30"
        calendar.update section
        expect($scope.getSections('16:00', 'Friday')[0]['style']['top']).toEqual '50%'
        expect($scope.getSections('16:00', 'Friday')[0]['style']['height']).toEqual '50%'

      it "updates the CSS correctly when end time changes", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['end_time'] = "17:30"
        calendar.update section
        expect($scope.getSections('16:00', 'Friday')[0]['style']['top']).toEqual '0%'
        expect($scope.getSections('16:00', 'Friday')[0]['style']['height']).toEqual '150%'

      it "marks the section as invalid when end time is earlier than the start time", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['start_time'] = "14:30"
        section['end_time'] = "16:00"
        calendar.update section
        expect($scope.getSections('16:00', 'Friday')[0]['isValid']).toBe false

      it "marks the section as invalid when end time has wrong format", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['end_time'] = "blergh"
        calendar.update section
        expect($scope.getSections('16:00', 'Friday')[0]['isValid']).toBe false

      it "marks the section as invalid when start time has wrong format", ->
        section = $scope.getSections('16:00', 'Friday')[0]
        section['start_time'] = "blergh"
        calendar.update section
        expect($scope.getSections('16:00', 'Friday')[0]['isValid']).toBe false


  describe "calendar.deleteSection", ->
    it 'calls the Section factory with correct parameters', ->
      sectionToDelete = fakeResults[4]
      calendar.deleteSection sectionToDelete
      expect(factoryMock.remove).toHaveBeenCalledWith sectionToDelete
    

    describe "section with a single weekday", ->
      it "deletes the event from the cell", ->
        sectionToDelete = fakeResults[4]
        calendar.deleteSection sectionToDelete
        expect($scope.getSections('16:00', 'Friday').length).toEqual 0


    describe "section with multiple weekdays", ->
      it "deletes the event from all the cells", ->
        sectionToDelete = fakeResults[0]
        calendar.deleteSection sectionToDelete
        expect($scope.getSections('10:00', 'Monday').length).toEqual 0
        expect($scope.getSections('10:00', 'Wednesday').length).toEqual 0

  
  describe "$scope.newSection(hour, weekday)", ->
    beforeEach ->
      calendar.newSection "14:00", "Monday"

    it 'calls the Section factory with correct parameters', ->
      expect(factoryMock.saveNew).toHaveBeenCalled()

    it "populates the cells corresponding to the hour and weekday", ->
      expect($scope.getSections('14:00', 'Monday')[0]['name']).toMatch /New/
      expect($scope.getSections('14:00', 'Wednesday')[0]['name']).toMatch /New/

    it "sets correct CSS attributes on the sections", ->
      expect($scope.getSections('14:00', 'Monday')[0]['style']['top']).toEqual '0%'
      expect($scope.getSections('14:00', 'Wednesday')[0]['style']['top']).toEqual '0%'
      expect($scope.getSections('14:00', 'Monday')[0]['style']['height']).toEqual '200%'
      expect($scope.getSections('14:00', 'Wednesday')[0]['style']['height']).toEqual '200%'
      

  describe "$scope.getSections(hour, weekday)", ->
    it 'is defined', ->
      expect($scope.getSections).toBeDefined()
      expect($scope.weekdays).toBe(jasmine.any(Function))
