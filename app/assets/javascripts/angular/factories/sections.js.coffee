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
        { 
          id: '@id',
        }, 
        { 
          'update': { method:'PUT' }, headers: {'Content-Type': 'application/json'},
          'post': headers: {'Content-Type': 'application/json'}
        }

    saveNew: (section, callback) ->
      newSection = new sectionResource buildParams(section)
      newSection.$save -> callback(newSection)

    update: (section, callback) ->
      section.$update(buildParams(section), -> callback section)
      
    remove: (section, callback) ->
      section.$remove -> callback(section)

    all: (callback) -> 
      all = sectionResource.query -> callback(all)
  }
]