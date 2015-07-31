@schedulerModule.factory 'Appointment', ['$resource', ($resource) -> 
  list = {}
  {
    init: (course_id) ->
      list = new schedulerApp.ResourceList(
        $resource, "#{gon.courses_api_path}/:id", 'course')
    saveNew: (params) -> null
    update: (course, params) -> null
    remove: (course) -> null
    all: -> list.all()
  }
]
