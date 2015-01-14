angular.module '<%= section %>'
  .provider '<%= module %>', !->

    salutation = 'A\'llo'

    @set-salutation = (s) !->
      salutation := s

    @$get = ->
      @some-method = -> salutation
      @
