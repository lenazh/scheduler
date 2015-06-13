@coursesModule.factory 'Course', ($resource) -> 
  class Course
    constructor: ()->
      @service = $resource "/api/courses/:id"

    create: (name) ->
      new @service(params).$save (entry) ->
        params.id = resource.id
      params

    update: (id, name) ->
      entry = @service.get {id: id}
      if (entry != null)
        entry.name = name
        entry.$save()
        
    remove: (id) ->
      @service.remove {id: id} 

    all: () ->
      @service.query()

  new Course()