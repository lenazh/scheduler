@coursesModule.factory 'Course', ($resource) -> 
  {
    init: ()->
      @course = $resource "/api/courses/:id", 
        { id: '@id' }, 
        { 
          'update': { method:'PUT' }, headers: {'Content-Type': 'application/json'},
          'post': headers: {'Content-Type': 'application/json'}
        }

#TODO - validations go here somewhere
    saveNew: (name) ->
      newCourse = new @course {name: name}
      newCourse.$save()
      newCourse

    update: (course, name, callback) ->
      @course.update {name: name}, course, callback
        
    remove: (course) ->
      @course.remove course

    all: () ->
      @course.query()
  }