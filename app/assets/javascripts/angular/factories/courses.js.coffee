@coursesModule.factory 'Course', ($resource) -> 
  {
    init: ()->
      @service = $resource "/api/courses/:id"

    create: (name) ->
      new @service(params).$save (entry) ->
        params.id = entry.id
      params

    update: (course, name) ->
      entry = @service.get {id: id}
      if (entry != null)
        entry.name = name
        entry.$save()
        
    remove: (course) ->
      @service.remove course

    all: () ->
      @service.query()
  }