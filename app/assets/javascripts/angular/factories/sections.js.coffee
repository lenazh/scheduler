@schedulerModule.factory 'Section', ['$resource', ($resource) -> 
  sectionResource = {}
  
  buildParams = (section) ->
    {
      'section[name]': section[name],
      'section[start_hour]': section[start_hour],
      'section[start_minute]': section[start_minute],
      'section[duration_hours]': section[duration_hours],
      'section[weekday]': section[weekday],
      'section[room]': section[room]
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
      section.$remove(callback)

    all: (callback) -> 
      all = sectionResource.query -> callback(all)
  }
]