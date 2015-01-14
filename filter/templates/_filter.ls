angular.module '<%= section %>'
  .filter '<%= module %>', ->
    (input) ->
      '<%= module %> filter: ' + input