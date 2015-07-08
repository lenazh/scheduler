@schedulerModule.directive 'calendarCell', ->
  {
    scope: {
      hour: '=',
      weekday: '='
    },
    restrict: 'A',
    require: '^sectionCalendar',
    link: (scope, element, attr, sectionCalendar) ->
      element.on 'mouseenter', (event) ->
        if element.find("div.event:not(.ghost)").length == 0
          element.find("div.ghost").delay("fast").show("fast")

      element.on 'mouseleave', (event) ->
        ghost = element.find("div.ghost")
        if ghost.is(':visible')
          ghost.hide("fast")
        else
          ghost.clearQueue()


  }