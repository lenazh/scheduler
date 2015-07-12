@schedulerModule.factory 'Navbar', ['$location', '$cookies', ($location, $cookies) -> 
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
  defaultTitle = "(please select a course to edit the calendar)"

  cookie_title = 'course_title'
  cookie_id = 'course_id'
  title = {}
  title['title'] = $cookies.get cookie_title
  title['title'] ||= defaultTitle
  title['id'] = $cookies.get cookie_id

  setCourse = (id, name) ->
    $cookies.put cookie_title, name
    $cookies.put cookie_id, id
    title['title'] = name
    title['id'] = $cookies.get cookie_id

  resetCourse = () ->
    $cookies.remove cookie_title
    $cookies.remove cookie_id
    title['title'] = defaultTitle
    title['id'] = null

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
    title: () -> title
    setCourse: (id, name) -> setCourse id, name
    resetCourse: () -> resetCourse()
  }
]