describe "Gsi", ->
  Resource = {}
  list = {}
  gon = {} 
  gon.courses_api_path = ''
  window.gon = gon
  course_id = 1

# initialize the dependencies and get the objects
  beforeEach module('schedulerApp')
  beforeEach ->
    inject (_Gsi_) ->
      Resource = _Gsi_
      list = Resource.init(course_id)

      spyOn(list, 'all')
      spyOn(list, 'remove')
      spyOn(list, 'update')
      spyOn(list, 'saveNew')

  it "has all() that calls through", ->
    Resource.all()
    expect(list.all).toHaveBeenCalled()

  it "has remove() that calls through", ->
    resourceToRemove = { 'id' : 234 }
    Resource.remove(resourceToRemove)
    expect(list.remove).toHaveBeenCalledWith(resourceToRemove)

  it "has saveNew(...) that calls through", ->
    params = { 'name' : 'Toaster', 'email' : 'toaster@example.com' }
    Resource.saveNew(params)
    expect(list.saveNew).toHaveBeenCalledWith(params)

  it "has update(...) that calls through", ->
    resourceToUpdate = { 'id' : 234 }
    params = { 'name' : 'Bread', 'email' : 'roasted@example.com' }
    Resource.update(resourceToUpdate, params)
    expect(list.update).toHaveBeenCalledWith(resourceToUpdate, params)
