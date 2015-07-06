@schedulerModule.controller 'calendarCtrl',  [() ->
  @content = "Section calendar goes here"

  @weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  
  @hours = []
  @hours.push "#{x}:00am" for x in [8..11]
  @hours.push "12:00pm"
  @hours.push "#{x}:00pm" for x in [1..8]



  return
]