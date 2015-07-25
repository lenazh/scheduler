@schedulerModule.factory 'Gsi', ['$resource', ($resource) -> 
  resource = {}
  all = []

  remove_from_list = (gsi) ->
    id = all.indexOf gsi
    return if id == -1
    all.splice id, 1

  append_to_list = (gsi) ->
    all.push gsi

  update_list = (id, gsi) ->
    all[id] = gsi

# expose the interface
  {
    init: (course_id) ->
      resource = $resource "#{gon.courses_api_path}/#{course_id}/gsis/:id", 
        { 
          id: '@id',
        }, 
        { 
          'update': { method:'PUT' }, headers: {'Content-Type': 'application/json'},
          'post': headers: {'Content-Type': 'application/json'}
        }

    saveNew: (params) ->
      newGsi = new resource(
        'email': params['email'],
        'hours_per_week': params['hours_per_week']
      )
      newGsi.$save(
        -> append_to_list(newGsi)
      )

    update: (gsi, params) ->
      id = all.indexOf gsi    
      return if id == -1
      resource.update(
        {
          'gsi[email]': params['email'],
          'gsi[hours_per_week]': params['hours_per_week']
        },
        gsi,
        (updated) -> update_list(id, updated)
      )
        
    remove: (gsi) ->
      resource.remove(
        {id: gsi['id']},
        -> remove_from_list(gsi)
      )

    all: () -> 
      all = resource.query()
      all
  }
]