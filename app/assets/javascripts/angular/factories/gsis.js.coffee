@schedulerModule.factory 'Gsi', ['$resource', ($resource) -> 
  list = {}
  {
    init: (course_id) ->
      list = new ResourceList(
        $resource, "#{gon.courses_api_path}/#{course_id}/gsis/:id", 'gsi')
    saveNew: (params) -> list.saveNew(params)
    update: (gsi, params) -> list.update(gsi, params)        
    remove: (gsi) -> list.remove(gsi)
    all: () -> list.all()
  }
]