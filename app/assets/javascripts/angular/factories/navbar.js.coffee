@schedulerModule.factory 'Navbar', ['$location', '$cookies', ($location, $cookies) -> 
  cookie_title = 'course_title'
  cookie_id = 'course_id'
  defaultTitle = "(please select a course to edit the calendar)"

  course = {}
  course['title'] = $cookies.get cookie_title
  course['title'] ||= defaultTitle
  course['id'] = $cookies.get cookie_id

  selected = null

  isCourseSelected = ->
    if course['id']
      return true
    else
      return false

  ifCourseSelected = (href) ->
    if isCourseSelected()
      return href
    else
      return ""

  items = [
    {
      title: "My Classes",
      active: "",
      href: () ->
        "#courses"
      selectable: () -> true
    },
    {
      title: "GSIs",
      active: "",
      href: () -> ifCourseSelected "#courses/#{course['id']}/gsi"
      selectable: () -> isCourseSelected()
    },
    {
      title: "Section calendar",
      active: "",
      href: () -> ifCourseSelected "#calendar/#{course['id']}"
      selectable: () -> isCourseSelected()
    }
  ]


  setCourse = (id, name) ->
    $cookies.put cookie_title, name
    $cookies.put cookie_id, id
    course['title'] = name
    course['id'] = $cookies.get cookie_id

  resetCourse = () ->
    $cookies.remove cookie_title
    $cookies.remove cookie_id
    course['title'] = defaultTitle
    course['id'] = null

  deselect = (item) ->
    item.active = "" if item

  select = (item) ->
    return unless item.selectable()
    item.active = "active"
    deselect selected 
    selected = item

  selectCurrentItem = ->
    location = $location.path().substring(1)
    for item in items
      if item.href().substring(1) == location
        select item
        return

  selectCurrentItem()

# Expose the interface
  {
    items: -> items
    select: (item) -> select item
    deselect: (item) -> deselect item
    course: () -> course
    setCourse: (id, name) -> setCourse id, name
    resetCourse: () -> resetCourse()
  }
]