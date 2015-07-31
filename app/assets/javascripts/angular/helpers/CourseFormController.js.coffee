class CourseFormController extends schedulerApp.AppointmentFormController

  form_is_valid: ->
    @_$scope.form.name.$valid

schedulerApp.CourseFormController = CourseFormController