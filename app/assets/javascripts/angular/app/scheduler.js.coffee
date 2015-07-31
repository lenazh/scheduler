# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@schedulerModule = angular.module 'schedulerApp', ['ngResource', 'ngRoute', 'ngCookies']

# send the cros-site forgery protection token for Rails
@schedulerModule.config ['$httpProvider', ($httpProvider)-> 
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
]

# Hash where all the helper functions are stored
window.schedulerApp = {}

# routing definitions

@schedulerModule.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when "/", {
      templateUrl: gon.courses_view_path,
      controller: 'CoursesCtrl',
      controllerAs: 'crs' 
    }

  $routeProvider.when "/courses", {
      templateUrl: gon.courses_view_path,
    }

  $routeProvider.when "/courses/:course_id/gsi", {
      templateUrl: gon.gsi_view_path,
      controller: 'GsiCtrl',
      controllerAs: 'gsiCtrl' 
    }

  $routeProvider.when "/calendar/:course_id", {
      templateUrl: gon.calendar_view_path,
    }
]