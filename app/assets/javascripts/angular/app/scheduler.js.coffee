# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@schedulerModule = angular.module 'schedulerApp', ['ngResource', 'ngRoute']

# send the cros-site forgery protection token for Rails
@schedulerModule.config ['$httpProvider', ($httpProvider)-> 
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
]

# routing definitions

@schedulerModule.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when "/", {
      templateUrl: gon.courses_view_path,
      controller: 'coursesCtrl',
      controllerAs: 'crs' 
    }

  $routeProvider.when "/courses", {
      templateUrl: gon.courses_view_path,
      controller: 'coursesCtrl',
      controllerAs: 'crs' 
    }

  $routeProvider.when "/gsi", {
      templateUrl: gon.gsi_view_path,
      controller: 'gsiCtrl',
      controllerAs: 'gsi' 
    }

  $routeProvider.when "/calendar/:course_id", {
      templateUrl: gon.calendar_view_path,
    }
]