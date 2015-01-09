describe 'The main view', (...) ->
  var page
  
  before-each ->
    browser.get 'http://localhost:3000/index.html'
    page := require './main.po'

  it 'should include jumbotron with correct data', ->
    expect page.h1-el.get-text! .to-be "'Allo, 'Allo!"
    expect (page.img-el.get-attribute 'src') .to-match /assets\/images\/yeoman.png$/
    expect (page.img-el.get-attribute 'alt') .to-be "I'm Yeoman"

  it 'should list more than 5 awesome things' ->
    expect page.thumbnail-els.count! .to-be-greater-than 5
