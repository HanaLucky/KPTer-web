App.board = App.cable.subscriptions.create "BoardChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    if data['kpcard']
      $('#boardWrap').append data['kpcard']

    if data['tcard']
      $('#boardWrap').append data['tcard']

    $('.cardBox').draggable();

  create_kpcard: (card_type, title, board_id, x, y) ->
    @perform 'create_kpcard', card_type: card_type, title: title, board_id: board_id, x: x, y: y

  create_tcard: (title, board_id, x, y) ->
    @perform 'create_tcard', title: title, board_id: board_id, x: x, y: y

  update_kpcard: (id, card_type, title, x, y) ->
    @perform 'update_kpcard', id: id, card_type: card_type, title: title, x: x, y: y

  update_tcard: (id, title, x, y) ->
    @perform 'update_tcard', title: title, x: x, y: y
