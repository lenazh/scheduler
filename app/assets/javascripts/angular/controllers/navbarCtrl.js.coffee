@schedulerModule.controller 'navbarCtrl',  ['$scope', '$location', ($scope, $location) ->

  @title = "8A Physics Berkeley Fall 2015"

  @items = [
    {
      title: "My Classes",
      active: "",
      href: "#courses"
    },
    {
      title: "GSIs",
      active: "",
      href: "#gsi"
    },
    {
      title: "Section calendar",
      active: "",
      href: "#calendar"
    }
  ]

  @selected = null

  @select = (item) ->
    item.active = "active"
    @deselect @selected 
    @selected = item

  @deselect = (item) ->
    item.active = "" if item

  @selectCurrentItem = ->
    location = $location.path().substring(1)
    for item in @items
      if item.href.substring(1) == location
        @select item
        return

  @selectCurrentItem()

  return
]