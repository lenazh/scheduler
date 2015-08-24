describe 'GSIs multiple lectures no time conflicts', ->
  sections = []
  gsis = []
  GSIs = {}

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
            ],
            'start_hour': 8, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 2, 'name': '102',
            'available_gsis': [
              { 'id': 2, 'preference': 0.75, 'hours_per_week': 80 },
              { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 }
            ],
            'start_hour': 10, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 3, 'name': '201',
            'available_gsis': [
              { 'id': 2, 'preference': 0.5, 'hours_per_week': 80 },
              { 'id': 3, 'preference': 0.25, 'hours_per_week': 10 }
            ],
            'start_hour': 12, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          },
          {
            'id': 4, 'name': '202',
            'available_gsis': [
              { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
              { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
            ],
            'start_hour': 14, 'start_minute': 0, 'duration_hours': 2.0,
            'weekday': 'Monday'
          }
        ]

      GSIs = new schedulerApp.GSIs(gsis)

    describe 'public methods', ->
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

      describe 'canTeach(gsi, section)', ->
        describe 'GSI has no hours left', ->
          it 'is false', ->
            gsi = gsis[2]
            GSIs.assign(gsi, section101)
            expect(GSIs.canTeach(gsi, section102)).toBe false
            expect(GSIs.canTeach(gsi, section201)).toBe false
            expect(GSIs.canTeach(gsi, section202)).toBe false

        describe 'GSI has hours left but teaches for a different lecture', ->
          it 'is false', ->
            GSIs.assign(gsi, section101)
            expect(GSIs.canTeach(gsi, section201)).toBe false
            expect(GSIs.canTeach(gsi, section202)).toBe false

        describe 'GSI has hours left and teaches no lectures', ->
          it 'is true', ->
            expect(GSIs.canTeach(gsi, section101)).toBe true
            expect(GSIs.canTeach(gsi, section102)).toBe true
            expect(GSIs.canTeach(gsi, section201)).toBe true
            expect(GSIs.canTeach(gsi, section202)).toBe true

        describe 'GSI has hours left and teaches the same lecture', ->
          it 'is true', ->
            GSIs.assign(gsi, section101)
            expect(GSIs.canTeach(gsi, section102)).toBe true

      describe 'assign', ->
        it 'decreases the GSI availability by one', ->
          availability = GSIs._availability(gsi)
          GSIs.assign gsi, section101
          expect(GSIs._availability(gsi)).toBe(availability - 1)

        it 'increases the number of sections the GSI is teaching in that \
        lecture by one without changin the other lectures', ->
          hours = GSIs._getHours gsi, section101
          GSIs.assign gsi, section101
          expect(GSIs._getHours(gsi, section101)).toBe(hours + 1)


      describe 'unassign', ->
        beforeEach ->
          GSIs.assign gsi, section101

        it 'increases the GSI availability by one', ->
          availability = GSIs._availability(gsi)
          GSIs.unassign gsi, section101
          expect(GSIs._availability(gsi)).toBe(availability + 1)

        it 'decreases the number of sections the GSI is teaching in that \
        lecture by one without changin the other lectures', ->
          hours = GSIs._getHours gsi, section101
          GSIs.unassign gsi, section101
          expect(GSIs._getHours(gsi, section101)).toBe(hours - 1)
          expect(GSIs._getHours(gsi, section201)).toBe 0


    describe 'private methods', ->
      describe '_teachingLecture(gsi, section)', ->
        it 'is false if the GSI has never been assigned to \
        sections within this lecture', ->
          expect(GSIs._teachingLecture(gsi, section101)).toBe false
          expect(GSIs._teachingLecture(gsi, section102)).toBe false
          expect(GSIs._teachingLecture(gsi, section201)).toBe false
          expect(GSIs._teachingLecture(gsi, section202)).toBe false

        it 'is true if the GSI was assigned to a section \
        within this lecture', ->
          GSIs.assign(gsi, section101)
          expect(GSIs._teachingLecture(gsi, section101)).toBe true
          expect(GSIs._teachingLecture(gsi, section102)).toBe true
          expect(GSIs._teachingLecture(gsi, section201)).toBe false
          expect(GSIs._teachingLecture(gsi, section202)).toBe false

        it 'is false if the GSI was assigned to a section within this \
        lecture and unassigned later', ->
          GSIs.assign(gsi, section101)
          GSIs.unassign(gsi, section101)
          expect(GSIs._teachingLecture(gsi, section101)).toBe false
          expect(GSIs._teachingLecture(gsi, section102)).toBe false

      describe '_teachingAnyOtherLecture(gsi, section)', ->
        describe 'GSI is teaching sections in a different lectures', ->
          it 'is true', ->
            GSIs.assign gsi, section101
            expect(GSIs._teachingAnyOtherLecture(gsi, section201))
              .toBe true

        describe 'GSI is teaching sections only in this lecture', ->
          it 'is false', ->
            GSIs.assign gsi, section101
            expect(GSIs._teachingAnyOtherLecture(gsi, section102))
              .toBe false

        describe 'GSI is not teaching any sections', ->
          it 'is false', ->
            expect(GSIs._teachingAnyOtherLecture(gsi, section102))
              .toBe false
            expect(GSIs._teachingAnyOtherLecture(gsi, section201))
              .toBe false

