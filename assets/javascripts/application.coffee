# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [100, 100]
  Dashing.numColumns ||= 5

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()

$ ->
  window.turn = 1

  $('li').on 'click', ->
    if window.turn is 1
      $(@).find('div').css 'background', 'white'
      transformNeighbors(@)
      checkForGameOver()
      window.turn = 2
    else
      $(@).find('div').css 'background', 'black'
      transformNeighbors(@)
      checkForGameOver()
      window.turn = 1

transformNeighbors = (that) ->
  row = $(that).data('row')
  col = $(that).data('col')

  $above = shift (row - 1), col
  $left  = shift row, (col - 1)
  $right = shift row, (col + 1)
  $below = shift (row + 1), col

  neighbors = [$above, $left, $right, $below]

  possess(square) for square in neighbors when enemy(square)

checkForGameOver = ->
  allsquares = $('li').find('div')
  num = 0
  for square in allsquares when green(square)
    num++
  alert 'Game Over' if num is 0

shift = (row, col) ->
  $('li[data-row="' + row + '"][data-col="' + col + '"]').find('div')

enemy = (direction) ->
  if whitesTurn() then color = 'rgb(0, 0, 0)' else color = 'rgb(255, 255, 255)'
  direction.css('background-color') is color

whitesTurn = ->
  window.turn is 1

blacksTurn = ->
  window.turn is 2

possess = (square) ->
  if whitesTurn() then color = 'white' else color = 'black'
  square.css('background-color', color)

green = (square) ->
  $(square).css('background-color') is 'rgb(0, 128, 0)'
