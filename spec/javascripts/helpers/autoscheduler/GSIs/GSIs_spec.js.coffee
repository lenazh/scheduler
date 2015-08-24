describe 'GSIs data object', ->
  gsis = []
  GSIs = {}

  vader = {}
  glados = {}
  honey = {}

  section101 = {}
  section102 = {}
  section201 = {}
  section202 = {}
  section404 = {}

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
        },
        {
          'id': 5, 'name': '404',
          'available_gsis': [
            { 'id': 1, 'preference': 0.25, 'hours_per_week': 20 },
            { 'id': 3, 'preference': 1.0, 'hours_per_week': 10 },
            { 'id': 2, 'preference': 0.25, 'hours_per_week': 80 }
          ],
          'start_hour': 16, 'start_minute': 0, 'duration_hours': 2.0,
          'weekday': 'Monday'
        }
      ]

    section101 = sections[0]
    section102 = sections[1]
    section201 = sections[2]
    section202 = sections[3]
    section404 = sections[4]

    vader = gsis[0]
    glados = gsis[1]
    honey = gsis[2]

    GSIs = new schedulerApp.GSIs(gsis)

  describe 'section_to_lecture', ->
    it 'returns the first symbol of the section name', ->
      expect(GSIs.section_to_lecture({ name: '103' })).toEqual '1'
      expect(GSIs.section_to_lecture({ name: '204' })).toEqual '2'
      expect(GSIs.section_to_lecture({ name: ' 404 ' })).toEqual '4'

  describe 'all', ->
    it 'returns the list of all GSIs', ->
      expect(GSIs.all()).toEqual gsis

  describe 'reset', ->
    beforeEach ->
      GSIs.reset()
      spyOn(GSIs, '_initializeGSI')

    it 'makes GSIs available for the number of sections\
    corresponding to his/her appointment', ->
      expect(GSIs.availability(vader)).toBe 2
      expect(GSIs.availability(glados)).toBe 4
      expect(GSIs.availability(honey)).toBe 1

    it 'calls _initializeGSI on every GSI', ->
      expect(GSIs._initializeGSI).toHaveBeenCalledWith vader
      expect(GSIs._initializeGSI).toHaveBeenCalledWith glados
      expect(GSIs._initializeGSI).toHaveBeenCalledWith honey

  describe 'canTeach(gsi, section)', ->
    describe 'when sections have no time conflicts', ->
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

    describe 'when sections have time conflicts', ->
      it 'checks something', ->

  describe 'assign', ->
    it 'decreases the GSI availability by one', ->
      availability = GSIs._availability(gsi)
      GSIs.assign gsi, section101
      expect(GSIs._availability(gsi)).toBe(availability - 1)

    it 'increases the number of sections the GSI is teaching in that \
    lecture by one without changin the other lectures', ->
      hours = GSIs._getSectionNumber gsi, section101
      GSIs.assign gsi, section101
      expect(GSIs._getSectionNumber(gsi, section101)).toBe(hours + 1)

    it 'adds the section to the list of section the GSI is teaching'


  describe 'unassign', ->
    beforeEach ->
      GSIs.assign gsi, section101

    it 'increases the GSI availability by one', ->
      availability = GSIs._availability(gsi)
      GSIs.unassign gsi, section101
      expect(GSIs._availability(gsi)).toBe(availability + 1)

    it 'decreases the number of sections the GSI is teaching in that \
    lecture by one without changin the other lectures', ->
      hours = GSIs._getSectionNumber gsi, section101
      GSIs.unassign gsi, section101
      expect(GSIs._getSectionNumber(gsi, section101)).toBe(hours - 1)
      expect(GSIs._getSectionNumber(gsi, section201)).toBe 0

    it 'removes the section from the list of sections the GSI is teaching'


  describe "'private' functions", ->
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

    describe '_getSectionNumber', ->
      it 'returns zero if the GSI is not teaching for any section', ->
        expect(GSIs._getSectionNumber).toEqual 0

      it 'returns one if the GSI is teaching one section \
      within this lecture', ->
        GSIs.assign(vader, section101)
        GSIs.assign(vader, section201)
        expect(GSIs._getSectionNumber(vader, section102)).toBe 1
        expect(GSIs._getSectionNumber(vader, section202)).toBe 1

      it 'returns zero if the GSI is teaching one section in \
      a different lecture', ->
        GSIs.assign(vader, section201)
        expect(GSIs._getSectionNumber(vader, section102)).toBe 0

      it 'returns the correct number if the GSI has been assigned \
      to a lecture and subsequently unassigned', ->
        GSIs.assign(vader, section101)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 1
        GSIs.assign(vader, section102)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 2
        GSIs.unassign(vader, section102)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 1
        GSIs.unassign(vader, section101)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 0

    describe '_changeSectionNumber', ->
      it 'changes the number of sections the GSI is teaching within \
      this lecture by a given amount', ->
        expect(GSIs._getSectionNumber(vader, section101)).toBe 0
        GSIs._changeSectionNumber(vader, section101, 3)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 3
        GSIs._changeSectionNumber(vader, section101, -2)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 1
        GSIs._changeSectionNumber(vader, section101, 0)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 1
        GSIs._changeSectionNumber(vader, section101, -1)
        expect(GSIs._getSectionNumber(vader, section101)).toBe 0