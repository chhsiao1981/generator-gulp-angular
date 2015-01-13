angular.module '<%= section %>'
  .directive '<%= module %>', ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the <%= module %> directive'

    