@schedulerModule.factory 'Course', ['$resource', ($resource) -> 
  {
    init: ()->
      @course = $resource "#{gon.courses_api_path}/:id", 
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
      @course.update {'course[name]': name}, course, callback
        
    remove: (course) ->
      @course.remove course

    all: () ->
      @course.query()
  }
]