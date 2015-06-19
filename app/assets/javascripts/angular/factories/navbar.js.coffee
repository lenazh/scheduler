@schedulerModule.factory 'Navbar', ['$location', ($location) -> 
  items = [
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

  selected = null

  deselect = (item) ->
    item.active = "" if item

  select = (item) ->
    item.active = "active"
    deselect selected 
    selected = item

  selectCurrentItem = ->
    location = $location.path().substring(1)
    for item in items
      if item.href.substring(1) == location
        select item
        return

  selectCurrentItem()

# Expose the interface
  {
    items: -> items
    select: (item) -> select item
    deselect: (item) -> deselect item
  }
]