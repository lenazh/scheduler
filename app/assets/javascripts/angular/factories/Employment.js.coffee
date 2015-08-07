@schedulerModule.factory 'Employment',
  ['$resource', '$http', ($resource, $http) ->
    list = {}
    baseUrl = ""
    {
      init: (course_id) ->
        baseUrl = "#{gon.courses_api_path}/#{course_id}/employments"
        list = new schedulerApp.ResourceList($resource,
          "#{baseUrl}/:id", 'employment')
      saveNew: (params) -> list.saveNew(params)
      update: (gsi, params) -> list.update(gsi, params)
      remove: (gsi) -> list.remove(gsi)
      all: -> list.all()
      roster: (success) -> 
        $http.get("#{baseUrl}/roster").then (result) -> success(result['data'])
    }
  ]