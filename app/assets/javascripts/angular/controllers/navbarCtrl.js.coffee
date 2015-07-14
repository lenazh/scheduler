@schedulerModule.controller 'navbarCtrl',  [ 'Navbar', (Navbar) ->

  @course = Navbar.course()

  @items = Navbar.items()

  @select = (item) ->
    Navbar.select item 

  return
]