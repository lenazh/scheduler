describe 'Autoscheduler', ->
  sections = []
  gsis = []
  scheduler = {}

  describe 'When a solution can be found', ->
    beforeEach ->
      gsis =
        [
          {
            'id': 1, 'name': 'Vader', 'hours_per_week': 20,
            'sections_can_teach': 2
          },
          {
            'id': 2, 'name': 'GlaDOS', 'hours_per_week': 80,
            'sections_can_teach': 4
          },
          {
            'id': 3, 'name': 'Honey Bunny', 'hours_per_week': 10,
            'sections_can_teach': 2
          },
        ]

      sections =
        [
          {
            'id': 1, 'name': '101',
            'available_gsis': [
              { 'id': 1, 'preference': 1.0, 'hours_per_week': 20 },
              { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
            ],
            'start_hour': 8, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 2, 'name': '102',
            'available_gsis': [
              { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
              { 'id': 3, 'preference': 0.75, 'hours_per_week': 10 },
              { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
            ],
            'start_hour': 10, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 3, 'name': '103',
            'available_gsis': [
              { 'id': 2, 'preference': 0.5, 'hours_per_week': 80 }
            ],
            'start_hour': 12, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 4, 'name': '104',
            'available_gsis': [
              { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
              { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
            ],
            'start_hour': 14, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          }
        ]

      scheduler = new schedulerApp.AutoScheduler(sections, gsis)
      GSIs = scheduler._GSIs
      scheduler.keepWithinTheSameLecture(false)

    describe 'maxHours()', ->
      it 'returns how many hours/week all GSIs can provide combined', ->
        maxHours = 0
        for gsi in gsis
          maxHours += gsi.hours_per_week
        expect(scheduler.maxHours()).toBe maxHours

    describe 'needHours()', ->
      it 'returns how many hours/week you need to teach all the sections', ->
        needHours = sections.length * 10
        expect(scheduler.needHours()).toBe needHours

    describe 'enoughGsiHours()', ->
      it 'returns true', ->
        expect(scheduler.enoughGsiHours()).toBe true

    describe 'sectionsNobodyCanTeach()', ->
      it 'returns an empty array', ->
        expect(scheduler.sectionsNobodyCanTeach()).toEqual []

    describe 'status()', ->
      it 'should be ready', ->
        expect(scheduler.status().join()).toMatch /Ready/

    describe 'solvable()', ->
      it 'should be true', ->
        expect(scheduler.solvable()).toBe true

    describe 'unemployed()', ->
      it "returns a list of underemployed GSIs and how many \
      more sections they can teach", ->
        GSIs = scheduler._GSIs
        spyOn(GSIs, 'availability').and.callFake (gsi) ->
          switch gsi.name
            when 'Vader' then 1
            when 'GlaDOS' then 6
            when 'Honey Bunny' then 0

        unemployed = scheduler.unemployed()
        expect(unemployed[0].name).toBe 'Vader'
        expect(unemployed[0]['unused_hours']).toBe 10
        expect(unemployed[1].name).toBe 'GlaDOS'
        expect(unemployed[1]['unused_hours']).toBe 60
        expect(unemployed[2]).not.toBeDefined()

    describe 'gsisWithNoPreferences()', ->
      it "returns a list of GSIs who didn't state their preferences or \
      didn't state enough to fulfill their appointment", ->
        result = scheduler.gsisWithNoPreferences()
        expect(result[0].name).toEqual 'GlaDOS'

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

    describe 'for any reason', ->
      solver = {}

      beforeEach ->
        spyOn(scheduler, 'solvable').and.returnValue false
        solver = scheduler._solver

      describe 'next()', ->
        it 'returns null', ->
          expect(scheduler.next()).toBe null

        it "doesn't call _solver.next()", ->
          spyOn(solver, 'next')
          scheduler.next()
          expect(solver.next).not.toHaveBeenCalled()

      describe 'previous()', ->
        it 'returns null', ->
          expect(scheduler.previous()).toBe null

        it "doesn't call _solver.previous()", ->
          spyOn(solver, 'previous')
          scheduler.previous()
          expect(solver.previous).not.toHaveBeenCalled()

      describe 'solution()', ->
        it 'returns null', ->
          expect(scheduler.solution()).toBe null

        it "doesn't call _solver.solution()", ->
          spyOn(solver, 'solution')
          scheduler.solution()
          expect(solver.solution).not.toHaveBeenCalled()

      describe 'quality()', ->
        it 'is 0.0', ->
          expect(scheduler.quality()).toBe 0.0
