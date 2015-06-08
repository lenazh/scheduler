# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@sectionsApp = angular.module('sections', ['ngRoute'])
 
@sectionsApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    otherwise({
      templateUrl: '../templates/sections.html',
      controller: 'SectionsCtrl'
    }) 
])