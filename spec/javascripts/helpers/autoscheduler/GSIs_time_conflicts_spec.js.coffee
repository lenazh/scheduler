describe 'GSIs data object', ->
  gsis = []
  GSIs = {}
  gsi = {}

  section1 = {}
  section2 = {}

  expect_success = (section1, section2)->
    GSIs.assign(gsi, section1)
    expect(GSIs.canTeach(gsi, section2)).toBe true

  expect_failure = (section1, section2)->
    GSIs.assign(gsi, section1)
    expect(GSIs.canTeach(gsi, section2)).toBe false  

  describe 'time conflicts', ->
    beforeEach ->
      gsis = [{ 'id': 2, 'name': 'GlaDOS', 'hours_per_week': 80 }]
      gsi = gsis[0]

      GSIs = new schedulerApp.GSIs(gsis)    

    describe 'Full hours single weekday', ->
      describe 'Monday 8:00-12:00 is scheduled then', ->
        beforeEach ->
          section1 = {
            'start_hour': 8, 'duration_hours': 4.0,
            'weekday': 'Monday', 'id': 1
            'start_minute': 0, 'name': '101'
          }

        describe 'Monday 8:00-12:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 4.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Tuesday 8:00-10:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 2.0,
              'weekday': 'Tuesday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 12:00-14:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 6:00-8:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 6, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 6:00-9:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 6, 'duration_hours': 3.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 11:00-13:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 11, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 8:00-9:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 1.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 9:00-10:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 9, 'duration_hours': 1.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:00-12:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)               

    describe 'Full hours multiple weekdays', ->
      describe 'Monday, Wednesday 10:00-12:00 is scheduled then', ->
        beforeEach ->
          section1 = {
            'start_hour': 10, 'duration_hours': 2.0,
            'weekday': 'Monday, Wednesday', 'id': 1
            'start_minute': 0, 'name': '101'
          }

        describe 'Tuesday, Thursday 10:00-12:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Tuesday, Thursday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Tuesday, Wednesday 10:00-12:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Tuesday, Wednesday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Tuesday, Monday 10:00-12:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Tuesday, Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Tuesday, Friday, Monday 11:00-13:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 11, 'duration_hours': 2.0,
              'weekday': 'Tuesday, Friday, Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Tuesday, Friday, Monday 12:00-14:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 2.0,
              'weekday': 'Tuesday, Friday, Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

    describe 'Fractional hours single weekday set #1', ->
      describe 'Monday 10:00-12:00 is scheduled then', ->
        beforeEach ->
          section1 = {
            'start_hour': 10, 'duration_hours': 2.0,
            'weekday': 'Monday', 'id': 1
            'start_minute': 0, 'name': '101'
          }

        describe 'Monday 12:30-14:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 11:30-13:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 11, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 8:30-10:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 7:30-9:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 7, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)           

    describe 'Fractional hours single weekday set #2', ->
      describe 'Monday 10:30-12:30 is scheduled then', ->
        beforeEach ->
          section1 = {
            'start_hour': 10, 'duration_hours': 2.0,
            'weekday': 'Monday', 'id': 1
            'start_minute': 30, 'name': '101'
          }

        describe 'Monday 8:30-10:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 8:20-10:20', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 20, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 8:40-10:40', ->
          beforeEach ->
            section2 = {
              'start_hour': 8, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 40, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:30-12:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:40-12:40', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 40, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:20-12:20', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 2.0,
              'weekday': 'Monday', 'id': 2
              'start_minute': 20, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:10-10:40', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 0.5,
              'weekday': 'Monday', 'id': 2
              'start_minute': 10, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:00-10:30', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 0.5,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 10:45-11:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 0.25,
              'weekday': 'Monday', 'id': 2
              'start_minute': 45, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 10:00-10:15', ->
          beforeEach ->
            section2 = {
              'start_hour': 10, 'duration_hours': 0.25,
              'weekday': 'Monday', 'id': 2
              'start_minute': 0, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 12:10-12:40', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 0.5,
              'weekday': 'Monday', 'id': 2
              'start_minute': 10, 'name': '102'
            }
          it 'creates a time conflict', ->
            expect_failure(section1, section2)

        describe 'Monday 12:30-13:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 0.5,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 12:30-12:45', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 0.25,
              'weekday': 'Monday', 'id': 2
              'start_minute': 30, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)

        describe 'Monday 12:45-13:00', ->
          beforeEach ->
            section2 = {
              'start_hour': 12, 'duration_hours': 0.25,
              'weekday': 'Monday', 'id': 2
              'start_minute': 45, 'name': '102'
            }
          it 'is OK to schedule', ->
            expect_success(section1, section2)            