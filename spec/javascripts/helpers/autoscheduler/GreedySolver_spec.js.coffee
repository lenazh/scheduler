describe 'Greedy solver', ->
  sections = []
  gsis = []
  solver = {}
  GSIs = {}

  describe 'Basic methods with empty data', ->
    beforeEach ->
      gsis = []
      sections = []

      GSIs = new schedulerApp.GSIs(gsis)
      solver = new schedulerApp.GreedySolver(sections, GSIs)

    describe 'public methods', ->
      describe 'reset', ->
        it 'calls _resetAllSections()', ->
          spyOn(solver, '_resetAllSections')
          solver.reset()
          expect(solver._resetAllSections).toHaveBeenCalled()

        it 'calls GSIs.reset()', ->
          spyOn(GSIs, 'reset')
          solver.reset()
          expect(GSIs.reset).toHaveBeenCalled()

    describe '"private" methods', ->
      describe '_findGsi(section, start, end)', ->
        section = {}

        beforeEach ->
          section = {
            name: '104'
            'available_gsis': [
              { name: 'GlaDOS' }, { name: 'Vader' }, { name: 'Kitten' }
            ]
          }

        describe "when no GSI can't teach", ->
          it 'calls GSIs.canTeach() on all GSIs between start and end', ->
            spyOn(GSIs, 'canTeach').and.returnValue false
            solver._findGsi(section, 0, 1)
            expect(GSIs.canTeach).
              toHaveBeenCalledWith { name: 'GlaDOS' }, section
            expect(GSIs.canTeach).
              toHaveBeenCalledWith { name: 'Vader' }, section

          it 'returns null', ->
            spyOn(GSIs, 'canTeach').and.returnValue false
            result = solver._findGsi(section, 0, 2)
            expect(result).toBe null

        describe 'when a GSI who can teach is found', ->
          it 'assigns the GSI to the section and returns it', ->
            spyOn(GSIs, 'canTeach').and.callFake (gsi) ->
              switch gsi.name
                when 'GlaDOS' then false
                when 'Vader' then false
                when 'Kitten' then true
                else false
            spyOn(solver, '_assign')
            result = solver._findGsi(section, 0, 2)
            expect(solver._assign).
              toHaveBeenCalledWith { name: 'Kitten' }, section, 2
            expect(result).toEqual { name: 'Kitten' }

      describe '_nextGsi(section)', ->
        section = {}

        beforeEach ->
          section = { available_gsis: [{}, {}, {}, {}] }

        describe 'when there are no more GSIs', ->
          describe 'when the index is pointing at the last element', ->
            it 'returns null', ->
              section.lastGsiIndex = 3
              expect(solver._nextGsi(section)).toBe null

          describe 'when the index is pointing beyond the last element', ->
            it 'returns null', ->
              section.lastGsiIndex = 4
              expect(solver._nextGsi(section)).toBe null

        describe 'when there are more GSIs', ->
          it 'calls _findGsi() starting from next GSI ending with the last \
          GSI on the available GSIs list (example 1)', ->
            section.lastGsiIndex = 2
            spyOn(solver, '_findGsi')
            solver._nextGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 3, 3

          it 'calls _findGsi() starting from next GSI ending with the last \
          GSI on the available GSIs list (example 2)', ->
            section.lastGsiIndex = 1
            spyOn(solver, '_findGsi')
            solver._nextGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 2, 3

          it 'calls _findGsi() starting from next GSI ending with the last \
          GSI on the available GSIs list (example 3)', ->
            section.lastGsiIndex = 0
            spyOn(solver, '_findGsi')
            solver._nextGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 1, 3

      describe '_previousGsi(section)', ->
        section = {}

        beforeEach ->
          section = { available_gsis: [{}, {}, {}, {}] }

        describe 'when there are no more GSIs', ->
          describe 'when the index is pointing at the first element', ->
            it 'returns null', ->
              section.lastGsiIndex = 0
              expect(solver._previousGsi(section)).toBe null

          describe 'when the index is pointing beyond the first element', ->
            it 'returns null', ->
              section.lastGsiIndex = -1
              expect(solver._previousGsi(section)).toBe null

        describe 'when there are more GSIs', ->
          it 'calls _findGsi() starting from next GSI ending with the first \
          GSI on the available GSIs list (example 1)', ->
            section.lastGsiIndex = 4
            spyOn(solver, '_findGsi')
            solver._previousGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 3, 0

          it 'calls _findGsi() starting from next GSI ending with the first \
          GSI on the available GSIs list (example 2)', ->
            section.lastGsiIndex = 2
            spyOn(solver, '_findGsi')
            solver._previousGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 1, 0

          it 'calls _findGsi() starting from next GSI ending with the first \
          GSI on the available GSIs list (example 3)', ->
            section.lastGsiIndex = 3
            spyOn(solver, '_findGsi')
            solver._previousGsi(section)
            expect(solver._findGsi).toHaveBeenCalledWith section, 2, 0

      describe 'functions updating the index', ->
        section = {}
        beforeEach ->
          section = { 'available_gsis': [{}, {}, {}] }

        describe '_setIndexAfterLast', ->
          describe 'searching forward', ->
            it 'sets the index correctly', ->
              solver._setIndexAfterLast section, true
              expect(section.lastGsiIndex).toBe 3

          describe 'searching backward', ->
            it 'sets the index correctly', ->
              solver._setIndexAfterLast section, false
              expect(section.lastGsiIndex).toBe -1

        describe '_setIndexBeforeFirst', ->
          describe 'searching forward', ->
            it 'sets the index correctly', ->
              solver._setIndexBeforeFirst section, true
              expect(section.lastGsiIndex).toBe -1

          describe 'searching backward', ->
            it 'sets the index correctly', ->
              solver._setIndexBeforeFirst section, false
              expect(section.lastGsiIndex).toBe 3

        describe '_assignSection(section, gsi, index)', ->
          section = {}

          beforeEach ->
            section = {}
            solver._assignSection section, { name: 'FakeGsi'}, 5

          it 'assigns the lastGsi', ->
            expect(section.lastGsi).toEqual { name: 'FakeGsi'}

          it 'assigns the lastGsiIndex', ->
            expect(section.lastGsiIndex).toBe 5

        describe '_resetSectionIndex(section)', ->
          section = {}

          beforeEach ->
            section = {}
            solver._resetSectionIndex section

          it 'sets the last section index before the first section', ->
            expect(section.lastGsiIndex).toBe -1

          it 'sets the lastGsi to null', ->
            expect(section.lastGsi).toBe null

      describe '_assign(gsi, section, index)', ->
        beforeEach ->
          spyOn(solver, '_assignSection')
          spyOn(GSIs, 'assign')
          solver._assign({ name: 'FakeGsi'}, { name: 'FakeSection' }, 4)

        it 'calls solver._assignSection(...) with correct parameters', ->
          expect(solver._assignSection)
            .toHaveBeenCalledWith { name: 'FakeSection' },
              { name: 'FakeGsi'}, 4

        it 'calls GSIs.assign(...) with correct parameters', ->
          expect(GSIs.assign)
            .toHaveBeenCalledWith { name: 'FakeGsi'}, { name: 'FakeSection' }

      describe '_unassign(gsi, section, index)', ->
        beforeEach ->
          spyOn(GSIs, 'unassign')
          solver._unassign { name: 'FakeGsi'}, { name: 'FakeSection' }

        it 'calls GSIs.unassign(...) with correct parameters', ->
          expect(GSIs.unassign)
            .toHaveBeenCalledWith { name: 'FakeGsi'},
              { name: 'FakeSection', lastGsi: null }

  describe 'finding a solution', ->
    expectSolution = (actual, expected) ->
      # console.log "Actual solution:"
      # console.log actual
      # console.log "Expected solution:"
      # console.log expected
      for key, value of expected
        expect(actual[key].id).toEqual value

    expectData = (data) ->
      for dataset in data
        expectedSolution = dataset.solution
        expectedQuality = dataset.quality
        next = dataset.next
        if (next)
          solver.next()
          solution = solver.testSolution()
        else
          solver.previous()
          solution = solver.testSolution()
        quality = solver.quality()
        # console.log solution
        # console.log "Quality = #{quality}"
        expectSolution solution, expectedSolution
        expect(quality).toEqual expectedQuality

    describe 'without time conflicts', ->
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

        GSIs = new schedulerApp.GSIs(gsis)
        solver = new schedulerApp.GreedySolver(sections, GSIs)

      it 'returns expected solutions', ->
        expectedData = [
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 3 },
            quality: (3.25 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: true
            },
          {
            solution: { 1: 1, 2: 3, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 3 },
            quality: (2.75 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 2 },
            quality: (2.0 / 4.0), next: true
          },
          {
            solution: { 1: 2, 2: 2, 3: 2, 4: 3 },
            quality: (2.5 / 4.0), next: true
          },
          {
            solution: { 1: 2, 2: 2, 3: 2, 4: 2 },
            quality: (1.75 / 4.0), next: true
          },
          {
            solution: { 1: 2, 2: 3, 3: 2, 4: 2 },
            quality: (1.75 / 4.0), next: true
          },
          {
            solution: { 1: 2, 2: 1, 3: 2, 4: 3 },
            quality: (2.0 / 4.0), next: true
          },
          {
            solution: { 1: 2, 2: 1, 3: 2, 4: 2 },
            quality: (1.25 / 4.0), next: true
          },
          { solution: null, quality: 0.0, next: true },
          { solution: null, quality: 0.0, next: true },
          { solution: null, quality: 0.0, next: true },
          {
            solution: { 1: 2, 2: 1, 3: 2, 4: 2 },
            quality: (1.25 / 4.0), next: false
          },
          {
            solution: { 1: 2, 2: 1, 3: 2, 4: 3 },
            quality: (2.0 / 4.0), next: false
          },
          {
            solution: { 1: 2, 2: 3, 3: 2, 4: 2 },
            quality: (1.75 / 4.0), next: false
          },
          {
            solution: { 1: 2, 2: 2, 3: 2, 4: 2 },
            quality: (1.75 / 4.0), next: false
          },
          {
            solution: { 1: 2, 2: 2, 3: 2, 4: 3 },
            quality: (2.5 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 2 },
            quality: (2.0 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 3 },
            quality: (2.75 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 3, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 3 },
            quality: (3.25 / 4.0), next: false
          },
          { solution: null, quality: 0.0, next: false },
          { solution: null, quality: 0.0, next: false },
          { solution: null, quality: 0.0, next: false },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 3 },
            quality: (3.25 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 3, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 3 },
            quality: (2.75 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 2 },
            quality: (2.0 / 4.0), next: true
          },
          {
            solution: { 1: 1, 2: 1, 3: 2, 4: 3 },
            quality: (2.75 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 3, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 2 },
            quality: (2.5 / 4.0), next: false
          },
          {
            solution: { 1: 1, 2: 2, 3: 2, 4: 3 },
            quality: (3.25 / 4.0), next: false
          }
        ]
        expectData expectedData


    describe 'with time conflicts', ->
      beforeEach ->
        gsis =
          [
            { 'id': 1, 'hours_per_week': 20, 'name': 'Vader' },
            { 'id': 2, 'hours_per_week': 20, 'name': 'GlaDOS' },
          ]

        sections =
          [
            {
              'id': 1, 'name': '101',
              'available_gsis': [
                { 'id': 1, 'preference': 1.0, 'hours_per_week': 20 },
                { 'id': 2, 'preference': 0.25, 'hours_per_week': 20 }
              ],
              'start_hour': 8, 'start_minute': 0, 'duration_hours': 2.0,
              'weekday': 'Monday'
            },
            {
              'id': 2, 'name': '102',
              'available_gsis': [
                { 'id': 2, 'preference': 1.0, 'hours_per_week': 20 },
                { 'id': 1, 'preference': 0.5, 'hours_per_week': 20 }
              ],
              'start_hour': 10, 'start_minute': 0, 'duration_hours': 2.0,
              'weekday': 'Monday'
            },
            {
              'id': 3, 'name': '103',
              'available_gsis': [
                { 'id': 2, 'preference': 0.75, 'hours_per_week': 20 }
              ],
              'start_hour': 10, 'start_minute': 0, 'duration_hours': 2.0,
              'weekday': 'Monday'
            }
          ]

        GSIs = new schedulerApp.GSIs(gsis)
        solver = new schedulerApp.GreedySolver(sections, GSIs)

      it 'returns expected solutions', ->
        expectedData = [
          {
            solution: { 1: 1, 2: 1, 3: 2 },
            quality: (2.25 / 3.0), next: true
          },
          {
            solution: { 1: 2, 2: 1, 3: 2 },
            quality: (1.5 / 3.0), next: true
          },
          { solution: null, quality: 0.0, next: true },
          { solution: null, quality: 0.0, next: true },
          {
            solution: { 1: 2, 2: 1, 3: 2 },
            quality: (1.5 / 3.0), next: false
          },
          {
            solution: { 1: 1, 2: 1, 3: 2 },
            quality: (2.25 / 3.0), next: false
          },
          { solution: null, quality: 0.0, next: false }
        ]
        expectData expectedData


