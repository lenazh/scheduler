@schedulerModule.factory 'Section', ['$resource', ($resource) -> 
  sectionResource = $resource "#{gon.sections_api_path}/:course_id/:id", 
    { 
      id: '@id',
      course_id: '@course_id'
    }, 
    { 
      'update': { method:'PUT' }, headers: {'Content-Type': 'application/json'},
      'post': headers: {'Content-Type': 'application/json'}
    }

# expose the interface
  {
    saveNew: (section, callback) ->
      newSection = new sectionResource {name: name, start: start, end: end, room: room}
      newSection.$save()
      append_to_list(newSection)

    update: (section, callback) ->
      oldSection = null
      sectionResource.update(
          {
            'section[name]': section[name],
            'section[start_hour]': section[start_hour],
            'section[start_minute]': section[start_minute],
            'section[duration_hours]': section[duration_hours],
            'section[weekday]': section[weekday],
            'section[room]': section[room]
          }, oldSection)

        
    remove: (section, callback) ->
      sectionResource.remove({id: section.id}, -> callback())

    all: (callback) -> 
      all = sectionResource.query -> callback(all)
  }
]