@schedulerModule.factory 'Preference', ['$http', ($http) -> 
  url = ''
  getUrl = ''
  setUrl = ''
  
  {
    init: (course_id) ->
      url = "#{gon.courses_api_path}/#{course_id}/preferences"
      getUrl = "#{url}/get"
      setUrl = "#{url}/set"

    set: (section, preference) ->
      $http.put setUrl, {
          'section_id': section.id
          'preference': preference
        }

    get: (section, callback) ->
      $http.get(getUrl, { params: { 'section_id': section.id } })
        .then(
          (result) ->
            callback(result.data.preference)
        )
  }
]