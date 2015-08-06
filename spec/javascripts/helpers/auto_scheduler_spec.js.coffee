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

    describe "'private' functions", ->
      describe '_prepareGsiIndex()', ->
        it 'stores number of sections GSIs can teach in _sectionsAvailable', ->
          expect(scheduler._sectionsAvailable[1]).toBe 2
          expect(scheduler._sectionsAvailable[2]).toBe 8
          expect(scheduler._sectionsAvailable[3]).toBe 1

      describe '_prepareSectionIndex()', ->
        it 'sets the last GSI to null for each section', ->
          _sections = scheduler._sections
          for section in _sections
            expect(section.lastGsi).toBe null
            expect(section.lastGsiIndex).toBe -1

      describe '_assign(gsi, section, index)', ->
        availability = 1
        gsi = {}
        section = {}
        index = 0

        beforeEach ->
          scheduler._sectionsAvailable[1] = availability
          _sections = scheduler._sections
          section = _sections[0]
          gsi = gsis[0]
          scheduler._assign(gsi, section, index)

        it 'decreases the number of sections the GSI can teach by one', ->
          expect(scheduler._sectionsAvailable[1]).toBe (availability - 1)

        it 'assigns _section.lastGsi', ->
          expect(scheduler._sections[0].lastGsi).toEqual gsi

        it 'assigns _sections.lastGsiIndex', ->
          expect(scheduler._sections[0].lastGsiIndex).toEqual index

      describe '_unassign(gsi, section)', ->
        availability = 1
        gsi = {}
        section = {}

        beforeEach ->
          scheduler._sectionsAvailable[1] = availability
          _sections = scheduler._sections
          section = _sections[0]
          gsi = gsis[0]
          scheduler._unassign(gsi, section)

        it 'increases the number of sections the GSI can teach by one', ->
          expect(scheduler._sectionsAvailable[1]).toBe (availability + 1)

      describe '_canTeach(gsi)', ->
        it 'returns true if the GSI can teach at least one section', ->
          scheduler._sectionsAvailable[1] = 1
          expect(scheduler._canTeach(gsis[0])).toBe true

        it 'returns false if the GSI can teach at zero sections', ->
          scheduler._sectionsAvailable[1] = 0
          expect(scheduler._canTeach(gsis[0])).toBe false

      describe '_findGsi(section, start, end)', ->
        describe 'GSI exists', ->
          gsi = {}
          section = {}
          index = 0

          beforeEach ->
            section = scheduler._sections[1]
            spyOn(scheduler, '_assign').and.callThrough()

          describe 'searching forward GSI exists', ->
            it 'returns correct GSI example 1', ->
              gsi = scheduler._findGsi(section, 1, 2)
              expect(gsi.id).toBe 3
              index = 1

            it 'returns correct GSI example 2', ->
              scheduler._sectionsAvailable[3] = 0
              gsi = scheduler._findGsi(section, 1, 2)
              expect(gsi.id).toBe 1
              index = 2

          describe 'searching backward GSI exists', ->
            it 'returns correct GSI example 1', ->
              gsi = scheduler._findGsi(section, 1, 0)
              expect(gsi.id).toBe 3
              index = 1

            it 'returns correct GSI example 2', ->
              scheduler._sectionsAvailable[3] = 0
              gsi = scheduler._findGsi(section, 1, 0)
              expect(gsi.id).toBe 2
              index = 0

          afterEach ->
            it 'assigns the GSI that has been found', ->
              expect(scheduler._assign).toHaveBeenCalledWith(gsi, section, index)

        describe "GSI doesn't exist", ->
          it 'returns null', ->
            section = scheduler._sections[1]
            scheduler._sectionsAvailable[1] = 0
            scheduler._sectionsAvailable[3] = 0
            gsi = scheduler._findGsi(section, 1, 2)
            expect(gsi).toBe null

      describe '_nextGsi()', ->
        section = {}
        beforeEach ->
          spyOn(scheduler, '_findGsi').and.callThrough()
          section = scheduler._sections[1]

        describe 'current GSI is the last one', ->
          beforeEach ->
            scheduler._assign(gsis[0], section, 2)   

          it 'returns null', ->
            gsi = scheduler._nextGsi(section)
            expect(gsi).toBe null

          it "doesn't call _findGsi(...)", ->
            gsi = scheduler._nextGsi(section)
            expect(scheduler._findGsi).not.toHaveBeenCalled()

        describe 'current GSI in not the last one', ->
          it 'calls _findGsi(...) with appropriate parameters', ->
            scheduler._assign(gsis[2], section, 1)
            gsi = scheduler._nextGsi(section)
            expect(scheduler._findGsi).toHaveBeenCalledWith(section, 2, 2)

      describe '_previousGsi()', ->
        section = {}
        beforeEach ->
          spyOn(scheduler, '_findGsi').and.callThrough()
          section = scheduler._sections[1]

        describe 'current GSI is the first one', ->
          beforeEach ->
            scheduler._assign(gsis[1], section, 0)   

          it 'returns null', ->
            gsi = scheduler._previousGsi(section)
            expect(gsi).toBe null

          it "doesn't call _findGsi(...)", ->
            gsi = scheduler._previousGsi(section)
            expect(scheduler._findGsi).not.toHaveBeenCalled()

        describe 'current GSI in not the first one', ->
          it 'calls _findGsi(...) with appropriate parameters', ->
            scheduler._assign(gsis[2], section, 1)
            gsi = scheduler._previousGsi(section)
            expect(scheduler._findGsi).toHaveBeenCalledWith(section, 0, 0)
