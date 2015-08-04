@schedulerModule.factory 'Navbar', ['$location', '$cookies', ($location, $cookies) -> 
  id_key = 'id'
  title_key = 'title'
  teaching_key = 'teaching'
  owner_key = 'owner'

  id_cookie = 'course_id'
  title_cookie = 'course_title'
  teaching_cookie = 'course_teaching'
  owner_cookie = 'course_owner'

  loadFromCookies = ->
    course[id_key] = $cookies.get id_cookie
    course[title_key] = $cookies.get title_cookie
    course[teaching_key] = $cookies.get teaching_cookie
    course[owner_key] = $cookies.get owner_cookie
    courseDefaults()

  saveToCookies = ->
    $cookies.put id_cookie, course[id_key]
    $cookies.put title_cookie, course[title_key]
    $cookies.put teaching_cookie, course[teaching_key]
    $cookies.put owner_cookie, course[owner_key]

  clearCookies = ->
    $cookies.remove id_cookie
    $cookies.remove title_cookie
    $cookies.remove owner_cookie
    $cookies.remove teaching_cookie

  courseDefaults = ->
    course[title_key] ||= "(please select a course to edit the calendar)"
    course[teaching_key] ||= false
    course[owner_key] ||= false

  course = {}
  loadFromCookies()
  selected = null

  isCourseSelected = ->
    if course[id_key]
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
      href: () -> "#courses"
      selectable: () -> true
    },
    {
      title: "GSIs",
      active: "",
      href: () -> ifCourseSelected "#courses/#{course['id']}/gsi"
      selectable: () -> isCourseSelected()
    },
    {
      title: "Schedule",
      active: "",
      href: () -> ifCourseSelected "#calendar/#{course['id']}"
      selectable: () -> isCourseSelected()
    }
  ]

  isSelected = (item) ->
    item.active != ''

  setCourse = (_course_) ->
    course = _course_
    saveToCookies()

  resetCourse = () ->
    clearCookies()
    loadFromCookies()

  deselect = (item) ->
    item.active = "" if item

  select = (item) ->
    return unless item.selectable()
    return if isSelected(item)
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
    title: () -> course['title']
    courseId: () -> course['id']
    setCourse: (course) -> setCourse course
    resetCourse: () -> resetCourse()
  }
]