@schedulerModule.factory 'Navbar', ['$location', '$cookies', ($location, $cookies) -> 
  cookie_title = 'course_title'
  cookie_id = 'course_id'
  defaultTitle = "(please select a course to edit the calendar)"

  title = {}
  title['title'] = $cookies.get cookie_title
  title['title'] ||= defaultTitle
  title['id'] = $cookies.get cookie_id

  selected = null


  items = [
    {
      title: "My Classes",
      active: "",
      href: "#courses",
      isCalendar: false
    },
    {
      title: "GSIs",
      active: "",
      href: "#gsi",
      isCalendar: false
    },
    {
      title: "Section calendar",
      active: "",
      href: "#calendar/",
      isCalendar: true
    }
  ]


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