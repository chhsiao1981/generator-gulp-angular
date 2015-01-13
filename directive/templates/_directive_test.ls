describe 'directive: <%= name %>', (...) ->
  before-each module '<%= section %>'

  scope = {}

  before-each inject ($controller, $root-scope) ->
    scope := $root-scope.$new!

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<<%= basename %>></<%= basename %>>'
    element = ($compile element) scope
    expect element.text! .to-be 'this is the <%= module %> directive'
