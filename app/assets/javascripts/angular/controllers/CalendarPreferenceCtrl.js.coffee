@schedulerModule.controller 'CalendarPreferenceCtrl',
  ['$scope', 'Navbar', 'Preference', ($scope, Navbar, Preference) ->
    $scope.preferences = [
      {
        label: "Can't make it"
        value: '0.0'
      },
      {
        label: "Not really",
        value: '0.25'
      },
      {
        label: "Ambivalent",
        value: '0.5'
      },
      {
        label: 'Yes',
        value: '0.75'
      },
      {
        label: 'Ideal fit for me',
        value: '1.0'
      }
    ]

    $scope.preference = '0.0'

    Preference.init(Navbar.courseId())

    $scope.toggleExpand = ($event) ->
      unless $scope.showEditForm
        Preference.get $scope.event,
          (preference) ->  $scope.preference = preference

      $scope.showEditForm = !$scope.showEditForm
      $event.stopPropagation()

    $scope.stopPropagation = ($event) ->
      $event.stopPropagation()

    $scope.set = ->
      Preference.set $scope.event, $scope.preference

  # TODO - move this to filters
    $scope.pad = (minutes) ->
      if (minutes < 10)
        return "0" + minutes
      else
        return minutes

    return
  ]