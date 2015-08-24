describe 'AutoScheduler single lecture no time conflicts', ->
  sections = []
  gsis = []
  scheduler = {}

  describe "When a solution can't be found", ->
    describe "because there are sections nobody can teach", ->
      beforeEach ->
        gsis =
          [
            { 'id': 1, 'hours_per_week': 20, 'name': 'Vader' },
            { 'id': 2, 'hours_per_week': 80, 'name': 'GlaDOS' },
            { 'id': 3, 'hours_per_week': 10, 'name': 'Honey Bunny' },
          ]

        sections =
          [
            {
              'id': 1, 'name': '101',
              'available_gsis': [],
              'start_hour': 8, 'start_minute': 0, 'duration_hours': 2.0,
              'weekday': 'Monday'
            },
            {
              'id': 2, 'name': '102',
              'available_gsis': [
                { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
                { 'id': 3, 'preference': 0.75, 'hours_per_week': 10 },
                { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
              ]
            },
            {
              'id': 3, 'name': '103',
              'available_gsis': [
                { 'id': 2, 'preference': 0.5, 'hours_per_week': 80 }
              ]
            },
            {
              'id': 4, 'name': '104',
              'available_gsis': [
                { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
                { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
              ]
            }
          ]

        scheduler = new schedulerApp.AutoScheduler(sections, gsis)
        scheduler._keepWithinTheSameLecture = false

      describe 'status()', ->
        it 'mentions that there are sections no GSI can teach', ->
          expect(scheduler.status().join()).toMatch /sections nobody can teach/

    describe "because there are not ehough GSIs", ->
      beforeEach ->
        gsis =
          [
            { 'id': 1, 'hours_per_week': 10, 'name': 'Vader' },
            { 'id': 2, 'hours_per_week': 10, 'name': 'GlaDOS' },
            { 'id': 3, 'hours_per_week': 10, 'name': 'Honey Bunny' },
          ]

        sections =
          [
            {
              'id': 1, 'name': '101',
              'available_gsis': [
                { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
                { 'id': 3, 'preference': 0.75, 'hours_per_week': 10 },
                { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
              ]
            },
            {
              'id': 2, 'name': '102',
              'available_gsis': [
                { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
                { 'id': 3, 'preference': 0.75, 'hours_per_week': 10 },
                { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
              ]
            },
            {
              'id': 3, 'name': '103',
              'available_gsis': [
                { 'id': 2, 'preference': 0.5, 'hours_per_week': 80 }
              ]
            },
            {
              'id': 4, 'name': '104',
              'available_gsis': [
                { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
                { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
              ]
            }
          ]

        scheduler = new schedulerApp.AutoScheduler(sections, gsis)
        scheduler._keepWithinTheSameLecture = false

      describe 'status()', ->
        it 'mentions that there are not enough GSIs', ->
          expect(scheduler.status().join()).toMatch /not enough GSIs/

    afterEach ->
      # not solvable
      expect(scheduler.solvable()).toBe false

      # previous/next returns null
      expect(scheduler.next()).toBe null
      expect(scheduler.next()).toBe null
      expect(scheduler.previous()).toBe null
      expect(scheduler.previous()).toBe null

      # quality is 0.0
      expect(scheduler.quality()).toBe 0.0

      # _fill() is not called
      spyOn(scheduler, '_fill')
      scheduler.next()
      scheduler.previous()
      expect(scheduler._fill).not.toHaveBeenCalled()