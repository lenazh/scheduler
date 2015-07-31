@schedulerModule.factory 'Employment', ['$resource', ($resource) -> 
  list = {}
  {
    init: (course_id) ->
      list = new schedulerApp.ResourceList(
        $resource, "#{gon.courses_api_path}/#{course_id}/employments/:id", 'employment')
    saveNew: (params) -> list.saveNew(params)
    update: (gsi, params) -> list.update(gsi, params)
    remove: (gsi) -> list.remove(gsi)
    all: -> list.all()
  }
]