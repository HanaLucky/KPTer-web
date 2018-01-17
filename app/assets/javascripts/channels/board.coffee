App.board = App.cable.subscriptions.create { channel: "BoardChannel", board_id: "#{$("#board_id").val()}" },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    card_id = ""
    if data['method'] is 'create'
      select_date = (date, id) ->
        unless window.fromServer
          App.board.set_deadline(id, date)
        return

      if data['kpcard']
        $('#boardWrap').append data['kpcard']
        card_id = "kp_" + data['id']
      else if data['tcard']
        $('#boardWrap').append data['tcard']
        card_id = "t_" + data['id']
        id = parseInt(data['id'], 10)
        date = new Date()
        year  = date.getFullYear()
        window.pickers[id] = new Pikaday(
          {
              field: document.getElementById("#{card_id}-datepicker-field"),
              trigger: document.getElementById("#{card_id}-datepicker"),
              ariaLabel: id,
              minDate: new Date(year - 2, 0, 1),
              maxDate: new Date(year + 2, 12, 31),
              yearRange: [year - 2, year + 2]
              onSelect: (-> select_date(window.pickers[id].getDate(), this._o.ariaLabel))
          });

      type = data['type']
      $("##{card_id}").data('type', type)
      $("##{card_id}").draggable({cancel: '.card-text'})

      $("##{card_id}").on 'blur', ->
        card = $(this)
        type = card.data('type')
        title = card.find('h4').text()
        offset = card.offset()
        if type is 'keep' || type is 'problem'
          App.board.update_kpcard(card[0].id.split("_")[1], title, offset.left, offset.top)
        else if type is 'try'
          App.board.update_tcard(card[0].id.split("_")[1], title, offset.left, offset.top)

      $("##{card_id}").find('.delete-btn').on 'click', ->
        if type is 'keep' || type is 'problem'
          App.board.delete_kpcard(data['id'])
        else if type is 'try'
          App.board.delete_tcard(data['id'])

        $("##{card_id}").remove()

      $("##{card_id}-like").on 'click', ->
        kLikeClass = 'mdl-color-text--blue-900'
        pLikeClass = 'mdl-color-text--pink-900'
        tLikeClass = 'mdl-color-text--light-green-900'
        noLikeClass = 'kpter-color-text--white'

        type = $(this)[0].dataset.type
        id = $(this)[0].dataset.id
        if type is 'keep' or type is 'problem'
          App.board.like_kpcard(id)
        else if type is 'try'
          App.board.like_tcard(id)

        if $(this).children(".material-icons").hasClass(kLikeClass)
          $(this).children(".material-icons").removeClass(kLikeClass)
          $(this).next('span').removeClass(kLikeClass)
        else if $(this).children(".material-icons").hasClass(pLikeClass)
          $(this).children(".material-icons").removeClass(pLikeClass)
          $(this).next('span').removeClass(pLikeClass)
        else if $(this).children(".material-icons").hasClass(tLikeClass)
          $(this).children(".material-icons").removeClass(tLikeClass)
          $(this).next('span').removeClass(tLikeClass)
        else
          if type is 'keep'
            $(this).children(".material-icons").addClass(kLikeClass)
            $(this).next('span').addClass(kLikeClass)
          else if type is 'problem'
            $(this).children(".material-icons").addClass(pLikeClass)
            $(this).next('span').addClass(pLikeClass)
          else if type is 'try'
            $(this).children(".material-icons").addClass(tLikeClass)
            $(this).next('span').addClass(tLikeClass)


    else if data['method'] is 'update'
      if data['kpcard']
        card_id = "kp_" + data['kpcard'].id
        card = $('#' + card_id)
        card.find('h4').text(data['kpcard'].title)
        card.offset({top: data['kpcard'].y, left: data['kpcard'].x})
      else if data['tcard']
        card_id = "t_" + data['tcard'].id
        card = $('#' + card_id)
        card.find('h4').text(data['tcard'].title)
        card.offset({top: data['tcard'].y, left: data['tcard'].x})

    else if data['method'] is 'delete'
      if (data['type'] is 'keep') or (data['type'] is 'problem')
        $("#kp_#{data['id']}").remove()
      else if data['type'] is 'try'
        $("#t_#{data['id']}").remove()

    else if data['method'] is 'like'
      if (data['type'] is 'keep') or (data['type'] is 'problem')
        $("#kp_#{data['id']}-like").next('span').text(data['num'])
      else if data['type'] is 'try'
        $("#t_#{data['id']}-like").next('span').text(data['num'])

    else if data['method'] is 'dislike'
      if (data['type'] is 'keep') or (data['type'] is 'problem')
        if data['num'] <= 0
          $("#kp_#{data['id']}-like").next('span').text("")
        else
          $("#kp_#{data['id']}-like").next('span').text(data['num'])
      else if data['type'] is 'try'
        if data['num'] <= 0
          $("#t_#{data['id']}-like").next('span').text("")
        else
          $("#t_#{data['id']}-like").next('span').text(data['num'])

    else if data['method'] is 'set_deadline'
      id = parseInt(data['id'], 10)
      window.fromServer = data['from_server']
      window.pickers[id].setDate(data['deadline'])
      window.fromServer = false

  create_kpcard: (card_type, title, board_id, x, y) ->
    @perform 'create_kpcard', card_type: card_type, title: title, board_id: board_id, x: x, y: y

  create_tcard: (title, board_id, x, y) ->
    @perform 'create_tcard', title: title, board_id: board_id, x: x, y: y

  update_kpcard: (id, title, x, y) ->
    @perform 'update_kpcard', id: id, title: title, x: x, y: y

  update_tcard: (id, title, x, y) ->
    @perform 'update_tcard', id: id, title: title, x: x, y: y

  delete_kpcard: (id) ->
    @perform 'delete_kpcard', id: id

  delete_tcard: (id) ->
    @perform 'delete_tcard', id: id

  like_kpcard: (id) ->
    @perform 'like_kpcard', id: id

  like_tcard: (id) ->
    @perform 'like_tcard', id: id

  set_deadline: (id, deadline) ->
    @perform 'set_deadline', id: id, deadline: deadline
