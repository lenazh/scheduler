@schedulerModule.factory 'Course', ['$resource', ($resource) -> 
  list = {}
  {
    init: (course_id) ->
      list = new schedulerApp.ResourceList(
        $resource, "#{gon.courses_api_path}/:id", 'course')
    saveNew: (params) -> list.saveNew(params)
    update: (course, params) -> list.update(course, params)        
    remove: (course) -> list.remove(course)
    all: () -> list.all()
  }
]
