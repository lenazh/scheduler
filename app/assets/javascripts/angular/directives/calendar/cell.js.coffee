@schedulerModule.directive 'calendarCell', ->
  {
    scope: {
      hour: '='
      weekday: '='
      },
    restrict: 'A',
    require: '^sectionCalendar',
    link: (scope, element, attr, sectionCalendar) ->

      element.on 'mouseenter', (event) ->
        if element.is(':empty')
          element.html "<div class='event-parent'><div class='event ghost' id='dog'>New section...</div></div>"
          element.find("div.event").on 'click', (event) ->
            sectionCalendar.newEvent(scope.hour, scope.weekday)

      element.on 'mouseleave', (event) ->
        if element.find("div.ghost").length > 0
          element.html ""       

  }