@schedulerModule.controller 'NavbarCtrl',  [ 'Navbar', (Navbar) ->

  @course = Navbar.course()

  @items = Navbar.items()

  @select = (item) ->
    Navbar.select item
    return

  return
]