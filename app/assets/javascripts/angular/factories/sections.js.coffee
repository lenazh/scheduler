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

  all = {}
  
  allSections = sectionResource.query()

  append_to_list = (section) ->
    all.push section

  update_list = (id, name) ->
    all[id]['name'] = name

# expose the interface
  {
    saveNew: (name, start, end, room) ->
      newSection = new sectionResource {name: name, start: start, end: end, room: room}
      newSection.$save()
      append_to_list(newSection)

    update: (section, name, start, end, room) ->
      id = all.indexOf section    
      return if id == -1
      courseResource.update(
          {
            'section[name]': name,
            'section[start]': start
            'section[end]': end
            'section[room]': room
          }, section)
      update_list(id, name)
        
    remove: (section) ->
      courseResource.remove({id: section.id})

    all: () -> all
  }
]