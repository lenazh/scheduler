@schedulerModule.factory 'Course', ['$resource', ($resource) -> 
  courseResource = $resource "#{gon.courses_api_path}/:id", 
    { id: '@id' }, 
    { 
      'update': { method:'PUT' }, 
      'headers': {'Content-Type': 'application/json'},
      'post': headers: {'Content-Type': 'application/json'}
    }

  all = courseResource.query()

  remove_from_list = (course) ->
    id = all.indexOf course
    return if id == -1
    all.splice id, 1

  append_to_list = (course) ->
    all.push course

  update_list = (id, name) ->
    all[id]['name'] = name

# expose the interface
  {
    saveNew: (name) ->
      newCourse = new courseResource {name: name}
      newCourse.$save()
      append_to_list(newCourse)

    update: (course, name) ->
      id = all.indexOf course    
      return if id == -1
      courseResource.update(
        {'course[name]': name},
        course,
        -> update_list(id, name)
      )
        
    remove: (course) ->
      courseResource.remove(
        {id: course.id},
        -> remove_from_list(course)
      )

    all: () -> all
  }
]