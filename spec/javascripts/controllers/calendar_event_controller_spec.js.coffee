describe "CalendarEventCtrl", ->
  $scope = {}
  $controller = {}
  event = {}
  calendarMock = {}
  mouseEventMock = {}
  ghostId = 0
  isFormValid = true

  beforeEach ->
    isFormValid = true

    calendarMock = {
      updateSection: (section, successCallback) ->
        successCallback() if isFormValid
      deleteSection: (section) ->
      saveSection: (section, successCallback) ->
        successCallback() if isFormValid
      deleteGhost: (section) ->
    }

    spyOn(calendarMock, 'updateSection').and.callThrough()
    spyOn(calendarMock, 'deleteSection')
    spyOn(calendarMock, 'saveSection').and.callThrough()
    spyOn(calendarMock, 'deleteGhost')

    mouseEventMock = {
      stopPropagation: () ->
    }

    spyOn(mouseEventMock, 'stopPropagation')

    $scope = {
      sectionCalendar: calendarMock
      editStyle: {
        'height': 'auto',
        'width': 'auto',
        'z-index': '200'
      }
      event: {
        "id": 7,
        "name": "108",
        "start_hour": 16,
        "start_minute": 0,
        "duration_hours": 1.5,
        "weekday": "Thursday",
        "room": "105",
        "gsi": {}
        "style": {}
      }
    }

    module "schedulerApp", () ->
      return

    inject (_$controller_) ->
      $controller = _$controller_

# expect every function call to stop the mouse event propagation
  afterEach ->
    expect(mouseEventMock.stopPropagation).toHaveBeenCalled()

  describe "Event that is already in the database (not a ghost)", ->
    beforeEach ->
      $scope['isGhost'] = false
      $scope['showEditForm'] = false
      event = $controller 'CalendarEventCtrl', {$scope: $scope}

    describe "when the form is clicked (toggleExpand(...) is called)", ->
      it "calls CalendarCtrl.updateSection when the form is expanded", ->
        $scope['showEditForm'] = true
        $scope.toggleExpand(mouseEventMock)
        expect(calendarMock.updateSection).toHaveBeenCalledWith(
          $scope.event, jasmine.any(Function))

      it "doesn't calls CalendarCtrl.updateSection when the form is collapsed", ->
        $scope['showEditForm'] = false
        $scope.toggleExpand(mouseEventMock)
        expect(calendarMock.updateSection).not.toHaveBeenCalled()

      it "expands the form if collapsed", ->
        $scope['showEditForm'] = false
        $scope.toggleExpand(mouseEventMock)
        expect($scope.showEditForm).toBe true

      it "collapses the form if expanded and the form is valid", ->
        $scope['showEditForm'] = true
        isFormValid = true
        $scope.toggleExpand(mouseEventMock)
        expect($scope.showEditForm).toBe false

      it "doesn't collapse the form if expanded and the form is invalid", ->
        $scope['showEditForm'] = true
        isFormValid = false
        $scope.toggleExpand(mouseEventMock)
        expect($scope.showEditForm).toBe true
      
    describe "when the update is clicked (update(...) is called)", ->
      it "calls CalendarCtrl.updateSection", ->
        $scope.update(mouseEventMock)
        expect(calendarMock.updateSection).toHaveBeenCalledWith(
          $scope.event, jasmine.any(Function))

    describe "when delete is clicked (delete(...) is called)", ->
      it "calls CalendarCtrl.deleteSection", ->
        $scope.delete(mouseEventMock)
        expect(calendarMock.deleteSection).toHaveBeenCalledWith($scope.event)


  describe "Event that is not in the database yet (ghost)", ->
    beforeEach ->
      $scope['isGhost'] = true
      $scope['showEditForm'] = true
      event = $controller 'CalendarEventCtrl', {$scope: $scope}

    describe "when cancel is clicked (cancel(...) is called)", ->
      it "calls CalendarCtrl.deleteGhost", ->
        $scope.cancel(mouseEventMock)
        expect(calendarMock.deleteGhost).toHaveBeenCalledWith($scope.event)

    describe "when save is clicked (save(...) is called)", ->
      it "calls CalendarCtrl.saveSection", ->
        $scope.save(mouseEventMock)
        expect(calendarMock.saveSection).toHaveBeenCalledWith(
          $scope.event, jasmine.any(Function))

      it "collapses the form if the form is valid", ->
        isFormValid = true
        $scope.save(mouseEventMock)
        expect($scope.showEditForm).toBe false

      it "doesn't collapse the form if the form is invalid", ->
        isFormValid = false
        $scope.save(mouseEventMock)
        expect($scope.showEditForm).toBe true

