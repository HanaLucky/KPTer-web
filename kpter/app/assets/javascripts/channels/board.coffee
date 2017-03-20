App.board = App.cable.subscriptions.create "BoardChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    alert data['x']
    $('#boardWrap').append data['message']

  create_tcard: (board_id, title, x, y) ->
    @perform 'create_tcard', board_id: board_id, title: title, x: x, y: y
