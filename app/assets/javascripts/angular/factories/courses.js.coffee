@coursesModule.factory 'Course', ($resource) -> 
  {
    init: ()->
      @course = $resource "/api/courses/:id", 
        { id: '@id' }, 
        { 'update': { method:'PUT' }}

#TODO - validations go here somewhere
    saveNew: (name) ->
      newCourse = new @course {name: name}
      newCourse.$save()
      newCourse

    update: (course, name) ->
      @course.update {name: name}, course
        
    remove: (course) ->
      @course.remove course

    all: () ->
      @course.query()
  }