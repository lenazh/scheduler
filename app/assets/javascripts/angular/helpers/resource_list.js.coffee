class window.ResourceList
  resourceLink = {}
  all = []
  fields = []
  name = ''

  remove_from_list = (resource) ->
    id = all.indexOf resource
    return if id == -1
    all.splice id, 1

  append_to_list = (resource) ->
    all.push resource

  update_list = (id, resource) ->
    all[id] = resource

  updateParams = (params) ->
    result = {}
    for key in fields
      result["#{name}[#{key}]"] = Object.keys(params)
    result

  # public interface

  constructor: ($resource, path, resourceName) ->
    resourceLink = $resource path, 
      { id: '@id' }, 
      { 
        'update': { method:'PUT' }, headers: {'Content-Type': 'application/json'},
        'post': headers: {'Content-Type': 'application/json'}
      }
    name = resourceName


  saveNew: (params) ->
    newResource = new resourceLink(params)
    newResource.$save(
      -> append_to_list(newResource)
    )

  update: (resourceToUpdate, params) ->
    id = all.indexOf resourceToUpdate  
    return if id == -1
    resourceLink.update(
      updateParams(params),
      resourceToUpdate,
      (updatedResource) ->
        update_list(id, updatedResource)
    )
      
  remove: (resourceToRemove) ->
    resourceToRemove.$remove(
      { id: resourceToRemove['id'] },
      () -> remove_from_list(resourceToRemove)
    )

  all: () -> 
    all = resourceLink.query()
    all
