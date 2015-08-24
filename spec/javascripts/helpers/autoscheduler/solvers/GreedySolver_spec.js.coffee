describe 'Greedy solver', ->
  sections = []
  gsis = []
  solver = {}
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
      solver = new schedulerApp.GreedySolver(sections, GSIs)

    describe 'public methods', ->