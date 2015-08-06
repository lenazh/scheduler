describe 'AutoScheduler', ->
  sections = []
  gsis = []
  scheduler = {}

  describe 'When a solution can be found and only one lecture exists', ->
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
            'available_gsis': [
              { 'id': 1, 'preference': 1.0 }, { 'id': 2, 'preference': 0.25 }
            ]
          },
          {
            'id': 2, 'name': '102',
            'available_gsis': [
              { 'id': 2, 'preference': 0.75 },
              { 'id': 3, 'preference': 0.75 },
              { 'id': 1, 'preference': 0.25 }
            ]
          },
          {
            'id': 3, 'name': '103',
            'available_gsis': [
              { 'id': 2, 'preference': 0.5 }
            ]
          },
          {
            'id': 4, 'name': '104',
            'available_gsis': [
              { 'id': 3, 'preference': 1.0 }, { 'id': 2, 'preference': 0.25 }
            ]
          }
        ]

      scheduler = new schedulerApp.AutoScheduler(sections, gsis)

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
