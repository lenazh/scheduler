@schedulerModule.controller 'navbarCtrl',  ['$scope', ($scope) ->

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

  return
]