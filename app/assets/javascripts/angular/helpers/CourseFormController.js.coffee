class CourseFormController extends schedulerApp.AppointmentFormController
  form_is_valid: ->
    @scope.form.name.$valid

schedulerApp.CourseFormController = CourseFormController