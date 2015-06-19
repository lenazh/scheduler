@schedulerModule.controller 'navbarCtrl',  [ 'Navbar', (Navbar) ->

  @title = "8A Physics Berkeley Fall 2015"

  @items = Navbar.items()

  @select = (item) ->
    Navbar.select item 

  return
]