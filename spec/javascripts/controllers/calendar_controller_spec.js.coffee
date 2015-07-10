describe "calendarCtrl", ->
  $scope = {}
  $controller = {}
  calendar = {}
  factoryMock = {}
  fakeResults = {}

  beforeEach ->
    fakeResults = [
      {
        "id": 1,
        "name": "101",
        "start_hour": 10,
        "start_minute": 15,
        "duration_hours": 1.75,
        "weekday" : "Monday, Wednesday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": 2,
        "name": "102",
        "start_hour": 12,
        "start_minute": 30,
        "duration_hours": 1.5,
        "weekday" : "Monday, Wednesday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": 3,
        "name": "103",
        "start_hour": 10,
        "start_minute": 0,
        "duration_hours": 2,
        "weekday" : "Monday, Wednesday",
        "room" : "106",
        "gsi" : {}
      },
      {
        "id": 4,
        "name": "104",
        "start_hour": 12,
        "start_minute": 0,
        "duration_hours": 2,
        "weekday" : "Tuesday, Thursday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": 5,
        "name": "106",
        "start_hour": 16,
        "start_minute": 0,
        "duration_hours": 1,
        "weekday" : "Friday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": 6,
        "name": "107",
        "start_hour": 14,
        "start_minute": 0,
        "duration_hours": 2.5,
        "weekday" : "Tuesday, Thursday",
        "room" : "105",
        "gsi" : {}
      },
      {
        "id": 7,
        "name": "108",
        "start_hour": 16,
        "start_minute": 0,
        "duration_hours": 1.5,
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
      saveNew: (section, callback) -> callback(),
      update: (section, callback) -> callback(),
      remove: (section, callback) -> callback()
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
    expect($scope.getSections('10:00', 'Monday')[1]['id']).toEqual 1
    expect($scope.getSections('10:00', 'Wednesday')[1]['id']).toEqual 1
    expect($scope.getSections('12:00', 'Monday')[2]['id']).toEqual 2
    expect($scope.getSections('12:00', 'Wednesday')[2]['id']).toEqual 2
    expect($scope.getSections('10:00', 'Monday')[3]['id']).toEqual 3
    expect($scope.getSections('10:00', 'Wednesday')[3]['id']).toEqual 3
    expect($scope.getSections('12:00', 'Tuesday')[4]['id']).toEqual 4
    expect($scope.getSections('12:00', 'Thursday')[4]['id']).toEqual 4
    expect($scope.getSections('16:00', 'Friday')[5]['id']).toEqual 5
    expect($scope.getSections('14:00', 'Tuesday')[6]['id']).toEqual 6
    expect($scope.getSections('14:00', 'Thursday')[6]['id']).toEqual 6
    expect($scope.getSections('16:00', 'Thursday')[7]['id']).toEqual 7

  it "sets CSS attributes 'top' and 'height' correctly", ->
    expect($scope.getSections('10:00', 'Monday')[1]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00', 'Monday')[1]['style']['height']).toEqual "175%"
    expect($scope.getSections('10:00', 'Wednesday')[1]['style']['top']).toEqual "25%"
    expect($scope.getSections('10:00', 'Wednesday')[1]['style']['height']).toEqual "175%"
    expect($scope.getSections('12:00', 'Monday')[2]['style']['top']).toEqual "50%" 
    expect($scope.getSections('12:00', 'Monday')[2]['style']['height']).toEqual "150%"
    expect($scope.getSections('12:00', 'Wednesday')[2]['style']['top']).toEqual "50%"
    expect($scope.getSections('12:00', 'Wednesday')[2]['style']['height']).toEqual "150%"
    expect($scope.getSections('10:00', 'Monday')[3]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00', 'Monday')[3]['style']['height']).toEqual "200%"
    expect($scope.getSections('10:00', 'Wednesday')[3]['style']['top']).toEqual "0%"
    expect($scope.getSections('10:00', 'Wednesday')[3]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00', 'Tuesday')[4]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00', 'Tuesday')[4]['style']['height']).toEqual "200%"
    expect($scope.getSections('12:00', 'Thursday')[4]['style']['top']).toEqual "0%"
    expect($scope.getSections('12:00', 'Thursday')[4]['style']['height']).toEqual "200%"
    expect($scope.getSections('16:00', 'Friday')[5]['style']['top']).toEqual "0%"
    expect($scope.getSections('16:00', 'Friday')[5]['style']['height']).toEqual "100%"
    expect($scope.getSections('14:00', 'Tuesday')[6]['style']['top']).toEqual "0%" 
    expect($scope.getSections('14:00', 'Tuesday')[6]['style']['height']).toEqual "250%" 
    expect($scope.getSections('14:00', 'Thursday')[6]['style']['top']).toEqual "0%" 
    expect($scope.getSections('14:00', 'Thursday')[6]['style']['height']).toEqual "250%" 
    expect($scope.getSections('16:00', 'Thursday')[7]['style']['top']).toEqual "0%" 
    expect($scope.getSections('16:00', 'Thursday')[7]['style']['height']).toEqual "150%" 

  it "mock sections are marked as valid", ->
    expect($scope.getSections('10:00', 'Monday')[1]['isValid']).toBeTruthy()
    expect($scope.getSections('10:00', 'Wednesday')[1]['isValid']).toBeTruthy()
    expect($scope.getSections('12:00', 'Monday')[2]['isValid']).toBeTruthy()
    expect($scope.getSections('12:00', 'Wednesday')[2]['isValid']).toBeTruthy()
    expect($scope.getSections('10:00', 'Monday')[3]['isValid']).toBeTruthy()
    expect($scope.getSections('10:00', 'Wednesday')[3]['isValid']).toBeTruthy()
    expect($scope.getSections('12:00', 'Tuesday')[4]['isValid']).toBeTruthy()
    expect($scope.getSections('12:00', 'Thursday')[4]['isValid']).toBeTruthy()
    expect($scope.getSections('16:00', 'Friday')[5]['isValid']).toBeTruthy()
    expect($scope.getSections('14:00', 'Tuesday')[6]['isValid']).toBeTruthy()
    expect($scope.getSections('14:00', 'Thursday')[6]['isValid']).toBeTruthy()
    expect($scope.getSections('16:00', 'Thursday')[7]['isValid']).toBeTruthy()

  describe 'calendar.updateSection', ->
    describe 'updating the weekday', ->
      it 'calls the Section factory with correct parameters', ->
        section = $scope.getSections('16:00', 'Friday')[5]
        section['weekday'] = "Monday"
        calendar.updateSection section
        expect(factoryMock.update).toHaveBeenCalled()


      describe 'section with a single weekday', ->
        it "when the weekday changes, the section is moved into the appropriate cell", ->
          expect($scope.getSections('16:00', 'Monday')[5]).not.toBeDefined()
          expect($scope.getSections('16:00', 'Friday')[5]).toBeDefined()
          section = $scope.getSections('16:00', 'Friday')[5]
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Monday')[5]).toBeDefined()
          expect($scope.getSections('16:00', 'Friday')[5]).not.toBeDefined()

        it "when another section is modified to have the same weekday it is appended to the cell", ->
          expect($scope.getSections('16:00', 'Friday')[7]).not.toBeDefined()
          section = $scope.getSections('16:00', 'Thursday')[7]
          section['weekday'] = "Thursday, Friday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[7]).toBeDefined()

        it "the section is given a second weekday, it remains
          in the original cell and is appended to the new cell", ->
          expect($scope.getSections('16:00', 'Monday')[5]).not.toBeDefined()
          expect($scope.getSections('16:00', 'Friday')[5]).toBeDefined()
          section = $scope.getSections('16:00', 'Friday')[5]
          section['weekday'] = "Friday, Monday"
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Monday')[5]).toBeDefined()
          expect($scope.getSections('16:00', 'Friday')[5]).toBeDefined()

        it 'updates the name correctly', ->
          expect($scope.getSections('16:00', 'Friday')[5]).toBeDefined()
          section = $scope.getSections('16:00', 'Friday')[5]
          name = "Kitten Gathering"
          section['name'] = name
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[5]['name']).toEqual name

        it 'updates the room correctly', ->
          expect($scope.getSections('16:00', 'Friday')[5]).toBeDefined()
          section = $scope.getSections('16:00', 'Friday')[5]
          room = "Cafe Strada"
          section['room'] = room
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[5]['room']).toEqual room


      describe 'section with two weekdays', ->
        it "when one weekday is removed the cells update accordingly", ->
          expect($scope.getSections('12:00', 'Monday')[2]).toBeDefined()
          expect($scope.getSections('12:00', 'Wednesday')[2]).toBeDefined()
          section = $scope.getSections('12:00', 'Monday')[2]
          section['weekday'] = "Monday"
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[2]).toBeDefined()
          expect($scope.getSections('12:00', 'Wednesday')[2]).not.toBeDefined()

        it "when the third weekday is added to an empty cell, the cells update accordingly", ->
          expect($scope.getSections('12:00', 'Monday')[2]).toBeDefined()
          expect($scope.getSections('12:00', 'Wednesday')[2]).toBeDefined()
          section = $scope.getSections('12:00', 'Monday')[2]
          section['weekday'] = "Monday, Wednesday, Friday"
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[2]).toBeDefined()
          expect($scope.getSections('12:00', 'Wednesday')[2]).toBeDefined()
          expect($scope.getSections('12:00', 'Friday')[2]).toBeDefined()

        it 'updates the name correctly', ->
          section = $scope.getSections('12:00', 'Monday')[2]
          name = "Kitten Gathering"
          section['name'] = name
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[2]['name']).toEqual name
          expect($scope.getSections('12:00', 'Wednesday')[2]['name']).toEqual name

        it 'updates the room correctly', ->
          section = $scope.getSections('12:00', 'Monday')[2]
          room = "Cafe Strada"
          section['room'] = room
          calendar.updateSection section
          expect($scope.getSections('12:00', 'Monday')[2]['room']).toEqual room
          expect($scope.getSections('12:00', 'Wednesday')[2]['room']).toEqual room


    describe 'updating the size', ->
      it "updates the CSS correctly when start time changes", ->
        section = $scope.getSections('16:00', 'Friday')[5]
        section['start_minute'] = 30
        calendar.updateSection section
        expect($scope.getSections('16:00', 'Friday')[5]['style']['top']).toEqual '50%'

      it "updates the CSS correctly when duration changes", ->
        section = $scope.getSections('16:00', 'Friday')[5]
        section['duration_hours'] = 1.5
        calendar.updateSection section
        expect($scope.getSections('16:00', 'Friday')[5]['style']['height']).toEqual '150%'

      describe "marks the section as invalid when", ->
        section = {}
        beforeEach ->
          section = $scope.getSections('16:00', 'Friday')[5]
        
        afterEach ->
          calendar.updateSection section
          expect($scope.getSections('16:00', 'Friday')[5]['isValid']).toBeFalsy()

        it "weekday is invalid", ->
          section["weekday"] = "Kittens"

        it "weekday is invalid and an array", ->
          section["weekday"] = "Monday, Tuesday, Kittens"

        it "start_hour has wrong format", ->
          section["start_hour"] = "Kittens"

        it "start_hour is negative", ->
          section["start_hour"] = "-10"

        it "start_hour is greater than 23", ->
          section["start_hour"] = "63"

        it "start_minute has wrong format", ->
          section["start_minute"] = "Kittens"

        it "start_minute is negative", ->
          section["start_minute"] = "-10"

        it "start_minute is greater than 59", ->
          section["start_minute"] = "63"

        it "duration_hours has wrong format", ->
          section["duration_hours"] = "Kittens"

        it "duration_hours is negative", ->
          section["duration_hours"] = "-10"

        it "duration_hours is greater than 10", ->
          section["duration_hours"] = "63"



  describe "calendar.deleteSection", ->
    it 'calls the Section factory with correct parameters', ->
      sectionToDelete = fakeResults[4]
      calendar.deleteSection sectionToDelete
      expect(factoryMock.remove).toHaveBeenCalledWith sectionToDelete, jasmine.any(Function)
    

    describe "section with a single weekday", ->
      it "deletes the event from the cell", ->
        sectionToDelete = fakeResults[4]
        calendar.deleteSection sectionToDelete
        expect($scope.getSections('16:00', 'Friday')[5]).not.toBeDefined()


    describe "section with multiple weekdays", ->
      it "deletes the event from all the cells", ->
        sectionToDelete = fakeResults[0]
        calendar.deleteSection sectionToDelete
        expect($scope.getSections('10:00', 'Monday')[1]).not.toBeDefined()
        expect($scope.getSections('10:00', 'Wednesday')[1]).not.toBeDefined()

  
  describe "$scope.newSection(hour, weekday)", ->
    beforeEach ->
      $scope.newSection "14:00", "Monday"

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
      expect($scope.getSections).toEqual jasmine.any(Function)
