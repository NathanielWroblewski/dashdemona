Dashdemona
=
Description
-

A [Dashing](http://shopify.github.com/dashing) dashboard to play an Othello-ish game.  Dashdemona is portmanteau of Dashing and Desdemona, Othello's 'ill-starred wench.'  Play a game [here](http://dashdemona.herokuapp.com/sample).

How to Play the Game
-
* Drag and drop a square to change its color.
* Squares of one color placed next to squares of the other color will 'possess' them.
* Dragging the squares can also change the layout of the board.
* Possess as many of your opponent's squares as you can to win.

*Changing the Board Layout*<br>
![Screen Shot of Changing the Board Layout](/assets/images/dashdemona_changing_layout.png)

*Possessing Adjacent Enemy Squares*<br>
![Screen Shot of Possessing Adjacent Enemy Squares](/assets/images/possess.png)

Useage
-
To use this dashboard, alter your `application.coffee` and your `.erb` dashboard layout, in this case `sample.erb`, in accordance with the code that follows.  Then, make a directory `widgets/dashdemona`, and fill it with the goodness of the `dashdemona.coffee`, `dashdemona.html`, and `dashdemona.scss` files included below.

Code
-

#####widgets/dashdemona/dashdemona.coffee

```coffee
class Dashing.Empty extends Dashing.Widget

  ready: ->
    $(@node).html('')

  onData: (data) ->
```



#####widgets/dashdemona/dashdemona.html

```HTML
<div class="empty">
</div>
```


#####widgets/dashdemona/dashdemona.scss

```SCSS
.empty {
  background-color: green;
}
```

#####dashboards/sample.erb

```ERB
<% content_for :title do %>My super sweet dashboard<% end %>
<div class="gridster">
  <ul>
    <% 20.times do %>
      <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
        <div data-id="empty" data-view="Empty"></div>
      </li>
    <% end %>
  </ul>
  <center><div style="font-size: 12px">Dashdemona</div></center>
</div>
```

#####assets/javascripts/application.coffee

```coffee
...
Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [100, 100]
  Dashing.numColumns ||= 5
...

$ ->
  window.turn = 1

  $('li').on 'click', ->
    square = $(@).find 'div'
    possess square
    transformNeighbors @
    checkForGameOver()
    if whitesTurn() then window.turn = 2 else window.turn = 1

transformNeighbors = (that) ->
  row = $(that).data 'row'
  col = $(that).data 'col'

  $above = shift (row - 1), col
  $left  = shift row, (col - 1)
  $right = shift row, (col + 1)
  $below = shift (row + 1), col

  neighbors = [$above, $left, $right, $below]

  possess square for square in neighbors when enemy square

checkForGameOver = ->
  allsquares = $('li').find 'div'
  num = 0
  num++ for square in allsquares when green square
  alert 'Game Over' if num is 0

shift = (row, col) ->
  $('li[data-row="' + row + '"][data-col="' + col + '"]').find 'div'

enemy = (direction) ->
  if whitesTurn() then color = 'rgb(0, 0, 0)' else color = 'rgb(255, 255, 255)'
  direction.css('background-color') is color

whitesTurn = ->
  window.turn is 1

possess = (square) ->
  if whitesTurn() then color = 'white' else color = 'black'
  square.css 'background-color', color

green = (square) ->
  $(square).css('background-color') is 'rgb(0, 128, 0)'

```
