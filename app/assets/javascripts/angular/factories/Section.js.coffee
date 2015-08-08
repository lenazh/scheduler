@schedulerModule.factory 'Section', ['$resource', '$http', ($resource, $http) -> 
  sectionResource = {}
  baseUrl = ""
  
  buildParams = (section) ->
    {
      'section': {
        'name': section['name'],
        'start_hour': section['start_hour'],
        'start_minute': section['start_minute'],
        'duration_hours': section['duration_hours'],
        'weekday': section['weekday'],
        'room': section['room']
      }
    }

  {
    init: (course_id) ->
      baseUrl = "#{gon.courses_api_path}/#{course_id}/sections"
      sectionResource = $resource "#{baseUrl}/:id", 
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
      sectionResource.update( 
        { 'id': section.id }
        buildParams(section) 
        (data) -> success data
        (e) -> error(e)
      )

    setGsi: (section, gsi_id, success, error) ->
      sectionResource.update( 
        { 'id': section.id }
        { 'section': { 'gsi_id': gsi_id } }
        (data) -> success data
        (e) -> error(e)
      )
      
    remove: (section, success) ->
      section.$remove -> success(section)

    all: (success) -> 
      all = sectionResource.query -> success(all)

    clear: (success) -> 
      $http.post("#{baseUrl}/clear").then (result) -> success(result['data'])
  }
]