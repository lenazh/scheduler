class ResourceList
  # "private" methods and fields
  _resourceLink: {}
  _all: []
  _name: ''

  _removeFromList: (resource) ->
    id = @_all.indexOf resource
    return if id == -1
    @_all.splice id, 1

  _appendToList: (resource) ->
    @_all.push resource

  _updateList: (id, resource) ->
    @_all[id] = resource

  _updateParams: (params) ->
    result = { "#{@_name}": {} }
    for key in Object.keys(params)
      result["#{@_name}"][key] = params[key]
    result

  # public interface

  constructor: ($resource, path, resourceName) ->
    @_resourceLink = $resource path,
      { 'id': '@id' },
      {
        'update': { 'method': 'PUT' },
        'headers': {'Content-Type': 'application/json'},
      }
    @_name = resourceName


  saveNew: (params) ->
    newResource = new @_resourceLink(@_updateParams(params))
    newResource.$save(
      => @_appendToList(newResource)
    )

  update: (resourceToUpdate, params) ->
    id = @_all.indexOf resourceToUpdate
    return if id == -1
    @_resourceLink.update(
      { 'id': resourceToUpdate.id },
      @_updateParams(params),
      (updatedResource) => @_updateList(id, updatedResource)
      ->
    )
      
  remove: (resourceToRemove) ->
    resourceToRemove.$remove(
      { id: resourceToRemove['id'] },
      => @_removeFromList(resourceToRemove)

    )

  all: ->
    @_all = @_resourceLink.query()
    @_all

schedulerApp.ResourceList = ResourceList