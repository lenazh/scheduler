describe 'AutoScheduler', ->
  sections = []
  gsis = []
  scheduler = {}

  describe 'When sections belong to different lectures', ->
    beforeEach ->
      gsis =
        [
          { 'id': 1, 'hours_per_week': 20, 'name': 'Vader' },
          { 'id': 2, 'hours_per_week': 40, 'name': 'GlaDOS' },
          { 'id': 3, 'hours_per_week': 10, 'name': 'Honey Bunny' },
        ]

      sections =
        [
          {
            'id': 1, 'name': '101',
            'available_gsis': [
              { 'id': 1, 'preference': 1.0, 'hours_per_week': 20 },
              { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
              { 'id': 3, 'preference': 0.75, 'hours_per_week': 10 }
            ]
          },
          {
            'id': 2, 'name': '102',
            'available_gsis': [
              { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
              { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
            ]
          },
          {
            'id': 3, 'name': '201',
            'available_gsis': [
              { 'id': 2, 'preference': 0.5, 'hours_per_week': 80 },
              { 'id': 3, 'preference': 0.25, 'hours_per_week': 10 }
            ]
          },
          {
            'id': 4, 'name': '202',
            'available_gsis': [
              { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
              { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
            ]
          }
        ]

      scheduler = new schedulerApp.AutoScheduler(sections, gsis)

    describe 'keep within same lecture', ->
      it 'is true by default', ->
        expect(scheduler._keepWithinTheSameLecture).toBe true

    describe 'getter', ->
      it 'returns the correct value', ->
        scheduler._keepWithinTheSameLecture = false
        expect(scheduler.keepWithinTheSameLecture()).toBe false
        scheduler._keepWithinTheSameLecture = true
        expect(scheduler.keepWithinTheSameLecture()).toBe true

    describe 'setter', ->
      it 'updates the value correctly', ->
        scheduler.keepWithinTheSameLecture true
        expect(scheduler._keepWithinTheSameLecture).toBe true
        scheduler.keepWithinTheSameLecture false
        expect(scheduler._keepWithinTheSameLecture).toBe false

    describe 'private methods', ->
      gsi = {}
      section101 = {}
      section102 = {}
      section201 = {}
      section202 = {}
      beforeEach ->
        gsi = gsis[0]
        section101 = sections[0]
        section102 = sections[1]
        section201 = sections[2]
        section202 = sections[3]

      describe '_canTeach(gsi, section)', ->
        describe 'GSI has no hours left', ->
          it 'is false', ->
            gsi = gsis[2]
            scheduler._assign(gsi, section101)
            expect(scheduler._canTeach(gsi, section102)).toBe false
            expect(scheduler._canTeach(gsi, section201)).toBe false
            expect(scheduler._canTeach(gsi, section202)).toBe false

        describe 'GSI has hours left but teaches for a different lecture', ->
          it 'is false', ->
            scheduler._assign(gsi, section101)
            expect(scheduler._canTeach(gsi, section201)).toBe false
            expect(scheduler._canTeach(gsi, section202)).toBe false

        describe 'GSI has hours left and teaches no lectures', ->
          it 'is true', ->
            expect(scheduler._canTeach(gsi, section101)).toBe true
            expect(scheduler._canTeach(gsi, section102)).toBe true
            expect(scheduler._canTeach(gsi, section201)).toBe true
            expect(scheduler._canTeach(gsi, section202)).toBe true

        describe 'GSI has hours left and teaches the same lecture', ->
          it 'is true', ->
            scheduler._assign(gsi, section101)
            expect(scheduler._canTeach(gsi, section102)).toBe true

      describe '_teachingLecture(gsi, section)', ->
        it 'is false if the GSI has never been assigned to \
        sections within this lecture', ->
          expect(scheduler._teachingLecture(gsi, section101)).toBe false
          expect(scheduler._teachingLecture(gsi, section102)).toBe false
          expect(scheduler._teachingLecture(gsi, section201)).toBe false
          expect(scheduler._teachingLecture(gsi, section202)).toBe false

        it 'is true if the GSI was assigned to a section \
        within this lecture', ->
          scheduler._assign(gsi, section101)
          expect(scheduler._teachingLecture(gsi, section101)).toBe true
          expect(scheduler._teachingLecture(gsi, section102)).toBe true
          expect(scheduler._teachingLecture(gsi, section201)).toBe false
          expect(scheduler._teachingLecture(gsi, section202)).toBe false

        it 'is false if the GSI was assigned to a section within this \
        lecture and unassigned later', ->
          scheduler._assign(gsi, section101)
          scheduler._unassign(gsi, section101)
          expect(scheduler._teachingLecture(gsi, section101)).toBe false
          expect(scheduler._teachingLecture(gsi, section102)).toBe false

      describe '_teachingAnyOtherLecture(gsi, section)', ->
        describe 'GSI is teaching sections in a different lectures', ->
          it 'is true', ->
            scheduler._assign gsi, section101
            expect(scheduler._teachingAnyOtherLecture(gsi, section201))
              .toBe true

        describe 'GSI is teaching sections only in this lecture', ->
          it 'is false', ->
            scheduler._assign gsi, section101
            expect(scheduler._teachingAnyOtherLecture(gsi, section102))
              .toBe false

        describe 'GSI is not teaching any sections', ->
          it 'is false', ->
            expect(scheduler._teachingAnyOtherLecture(gsi, section102))
              .toBe false
            expect(scheduler._teachingAnyOtherLecture(gsi, section201))
              .toBe false

      describe '_assign', ->
        it 'decreases the GSI availability by one', ->
          availability = scheduler._availability(gsi)
          scheduler._assign gsi, section101
          expect(scheduler._availability(gsi)).toBe(availability - 1)

        it 'increases the number of sections the GSI is teaching in that \
        lecture by one without changin the other lectures', ->
          hours = scheduler._getHours gsi, section101
          scheduler._assign gsi, section101
          expect(scheduler._getHours(gsi, section101)).toBe(hours + 1)


      describe '_unassign', ->
        beforeEach ->
          scheduler._assign gsi, section101

        it 'increases the GSI availability by one', ->
          availability = scheduler._availability(gsi)
          scheduler._unassign gsi, section101
          expect(scheduler._availability(gsi)).toBe(availability + 1)

        it 'decreases the number of sections the GSI is teaching in that \
        lecture by one without changin the other lectures', ->
          hours = scheduler._getHours gsi, section101
          scheduler._unassign gsi, section101
          expect(scheduler._getHours(gsi, section101)).toBe(hours - 1)
          expect(scheduler._getHours(gsi, section201)).toBe 0
