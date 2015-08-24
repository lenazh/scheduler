describe 'GSIs single lecture no time conflicts', ->
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

    describe "'public' functions", ->
      describe 'when initialized', ->
        it 'stores number of sections GSIs can teach', ->
          expect(GSIs.availability(gsis[0])).toBe 2
          expect(GSIs.availability(gsis[1])).toBe 8
          expect(GSIs.availability(gsis[2])).toBe 1

      describe 'assign(gsi, section, index)', ->
        availability = 1
        gsi = {}
        section = {}
        index = 0

        beforeEach ->
          gsi = gsis[0]
          GSIs._setAvailability(gsi, availability)
          _sections = scheduler._sections
          section = _sections[0]
          GSIs.assign(gsi, section, index)

        it 'decreases the number of sections the GSI can teach by one', ->
          expect(GSIs.availability(gsi)).toBe (availability - 1)

      describe 'unassign(gsi, section)', ->
        availability = 1
        gsi = {}
        section = {}

        beforeEach ->
          gsi = gsis[0]
          scheduler._setAvailability(gsi, availability)
          _sections = scheduler._sections
          section = _sections[0]
          scheduler._unassign(gsi, section)

        it 'increases the number of sections the GSI can teach by one', ->
          expect(scheduler._availability(gsi)).toBe (availability + 1)

      describe '_canTeach(gsi)', ->
        it 'returns true if the GSI can teach at least one section', ->
          scheduler._setAvailability(gsis[0], 1)
          expect(scheduler._canTeach(gsis[0]), null).toBe true

        it 'returns false if the GSI can teach at zero sections', ->
          scheduler._setAvailability(gsis[0], 0)
          expect(scheduler._canTeach(gsis[0]), null).toBe false

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
              scheduler._setAvailability(gsis[2], 0)
              gsi = scheduler._findGsi(section, 1, 2)
              expect(gsi.id).toBe 1
              index = 2

          describe 'searching backward GSI exists', ->
            it 'returns correct GSI example 1', ->
              gsi = scheduler._findGsi(section, 1, 0)
              expect(gsi.id).toBe 3
              index = 1

            it 'returns correct GSI example 2', ->
              scheduler._setAvailability(gsis[2], 0)
              gsi = scheduler._findGsi(section, 1, 0)
              expect(gsi.id).toBe 2
              index = 0

          afterEach ->
            it 'assigns the GSI that has been found', ->
              expect(scheduler._assign).
                toHaveBeenCalledWith(gsi, section, index)

        describe "GSI doesn't exist", ->
          it 'returns null', ->
            section = scheduler._sections[1]
            scheduler._setAvailability(gsis[0], 0)
            scheduler._setAvailability(gsis[2], 0)
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

      describe '_advanceGsi(section, next)', ->
        section = {}
        beforeEach ->
          spyOn(scheduler, '_nextGsi')
          spyOn(scheduler, '_previousGsi')
          section = scheduler._sections[1]

        describe 'next is false', ->
          it 'calls _previousGsi(...)', ->
            scheduler._advanceGsi(section, false)
            expect(scheduler._previousGsi).
              toHaveBeenCalledWith(section, section.lastGsi)

        describe 'next is true', ->
          it 'calls _nextGsi(...)', ->
            scheduler._advanceGsi(section, true)
            expect(scheduler._nextGsi).
              toHaveBeenCalledWith(section, section.lastGsi)