@schedulerModule.factory 'Appointment', ['$resource', ($resource) ->
  list = {}
  {
    init: (_unused) ->
      list = new schedulerApp.ResourceList(
        $resource, "#{gon.appointments_api_path}/:id", 'appointment')
    saveNew: (params) -> null
    update: (appointment, params) -> null
    remove: (appointment) -> null
    all: -> list.all()
  }
]
