class Dashing.Empty extends Dashing.Widget

  ready: ->
    $(@node).html('')

  onData: (data) ->
