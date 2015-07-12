@schedulerModule.controller 'navbarCtrl',  [ 'Navbar', (Navbar) ->

  @title = Navbar.title()

  @items = Navbar.items()

  @select = (item) ->
    Navbar.select item 

  return
]