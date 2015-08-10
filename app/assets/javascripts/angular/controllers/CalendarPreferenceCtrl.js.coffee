@schedulerModule.controller 'CalendarPreferenceCtrl',
  ['$scope', 'Navbar', 'Preference', ($scope, Navbar, Preference) ->
    gsiClass = (value) ->
      return "really-wants-section" if value >= 1.0
      return "wants-section" if 1.0 > value >= 0.75
      return "ok-with-section" if 0.75 > value >= 0.5
      return "doesnt-like-section" if 0.5 > value >= 0.25
      return "really-dislikes" if 0.25 > value > 0
      return "cant-make" if value == 0

    # the class that div containing the event gets
    $scope.eventClass = ->
      "event #{gsiClass($scope.event.preference)}"

    $scope.preferences = [
      {
        label: "Can't make it"
        value: 0.0
      },
      {
        label: "Not really",
        value: 0.25
      },
      {
        label: "Ambivalent",
        value: 0.5
      },
      {
        label: 'Yes',
        value: 0.75
      },
      {
        label: 'Ideal fit for me',
        value: 1.0
      }
    ]

    Preference.init(Navbar.courseId())

    $scope.toggleExpand = ($event) ->
      $scope.showEditForm = !$scope.showEditForm
      $event.stopPropagation()

    $scope.stopPropagation = ($event) ->
      $event.stopPropagation()

    $scope.set = ->
      Preference.set $scope.event, $scope.event.preference

  # TODO - move this to filters
    $scope.pad = (minutes) ->
      if (minutes < 10)
        return "0" + minutes
      else
        return minutes

    return
  ]