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
        element.find("div.ghost").delay("slow").show("fast")

      element.on 'mouseleave', (event) ->
        ghost = element.find("div.ghost")
        if ghost.is(':visible')
          ghost.hide("fast")
        else
          ghost.clearQueue()


  }