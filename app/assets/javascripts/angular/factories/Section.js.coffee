@schedulerModule.factory 'Section', ['$resource', ($resource) -> 
  sectionResource = {}
  
  buildParams = (section) ->
    {
      'name': section['name'],
      'start_hour': section['start_hour'],
      'start_minute': section['start_minute'],
      'duration_hours': section['duration_hours'],
      'weekday': section['weekday'],
      'room': section['room']
    }

  {
    init: (course_id) ->
      sectionResource = $resource "#{gon.courses_api_path}/#{course_id}/sections/:id", 
        { 'id': '@id' },
        {
          'update': { 'method': 'PUT' },
          'headers': {'Content-Type': 'application/json'},
        }
        
    saveNew: (section, success, error) ->
      newSection = new sectionResource buildParams(section)
      newSection.$save(
        -> success(newSection)
        (e) -> error(e)
      )

    update: (section, success, error) ->
      section.$update( 
        buildParams(section) 
        -> success section
        (e) -> error(e)
      )
      
    remove: (section, success) ->
      section.$remove -> success(section)

    all: (success) -> 
      all = sectionResource.query -> success(all)
  }
]