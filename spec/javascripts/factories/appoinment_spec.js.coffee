describe "Appointment", ->
  Resource = {}
  list = {}
  gon = {}
  gon.courses_api_path = ''
  window.gon = gon
  course_id = 1

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject (_Course_) ->
      Resource = _Course_
      list = Resource.init()

      spyOn(list, 'all')
      spyOn(list, 'remove')
      spyOn(list, 'update')
      spyOn(list, 'saveNew')

  it "has all() that calls through", ->
    Resource.all()
    expect(list.all).toHaveBeenCalled()
