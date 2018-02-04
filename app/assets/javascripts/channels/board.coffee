App.board = App.cable.subscriptions.create { channel: "BoardChannel", board_id: "#{$("#board_id").val()}" },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    card_id = ""
    if data['method'] is 'create'
      if data['kpcard'] 
        App.board.add_kpcard(data['kpcard'])
      else if data['tcard']
        App.board.add_tcard(data['tcard'])
 
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

  # update card
  update_kpcard: (_this, title) ->
    id = _this[0].id.split("_")[1]
    type = _this[0].dataset.type
    offset = _this.offset()
    @perform 'update_kpcard', id: id, title: title, x: offset.left, y:offset.top

  update_tcard: (_this, title) ->
    id = _this[0].id.split("_")[1]
    type = _this[0].dataset.type
    offset = _this.offset()
    @perform 'update_tcard', id: id, title: title, x: offset.left, y: offset.top

  select_date: (date, id) ->
    unless window.fromServer
      App.board.set_deadline(id, date)
    return

  initialize_buttons: (_this) ->
    $boardWrap = $('#boardWrap')
    board_id = $('[name=board_id]').val()
    type = _this.data('type').toString()
    title = ""
    offset =  _this.offset()

    if type is 'keep' or type is 'problem' 
      App.board.create_kpcard(type, title, board_id, offset.left, offset.top)
    else if type is 'try'
      App.board.create_tcard(title, board_id, offset.left, offset.top)
  
  initialize_cards: ->
    window.fromServer = false
    window.pickers = []

    for card in kp_cards
      App.board.add_kpcard(card)

    for card in t_cards
      App.board.add_tcard(card)
      
  add_kpcard: (card) ->
    type_id = "kp_#{card.id}"
      
    addingCard = App.board.adding_kpcard(card, type_id)
    $('#boardWrap').append addingCard
    addingCard.offset(top: card.y, left: card.x)
    $("##{type_id}").draggable({cancel: '.card-text'})

    $("##{type_id}").on 'dragstop', ->
      title = $(this).find(".card-text").text()
      App.board.update_kpcard($(this), title)
    $("##{type_id}-text").on 'blur', ->
      title = $(this).text()
      App.board.update_kpcard($(this), title)
    $("##{type_id}-like").on 'click', ->
      kLikeClass = 'mdl-color-text--blue-900'
      pLikeClass = 'mdl-color-text--pink-900'
      noLikeClass = 'kpter-color-text--white'

      type = $(this)[0].dataset.type
      id = $(this)[0].dataset.id
      App.board.like_kpcard(id)

      if $(this).children(".material-icons").hasClass(kLikeClass)
        $(this).children(".material-icons").removeClass(kLikeClass)
        $(this).next('span').removeClass(kLikeClass)
      else if $(this).children(".material-icons").hasClass(pLikeClass)
        $(this).children(".material-icons").removeClass(pLikeClass)
        $(this).next('span').removeClass(pLikeClass)
      else
        if type is 'keep'
          $(this).children(".material-icons").addClass(kLikeClass)
          $(this).next('span').addClass(kLikeClass)
        else if type is 'problem'
          $(this).children(".material-icons").addClass(pLikeClass)
          $(this).next('span').addClass(pLikeClass)   
    $("##{type_id}").find('.delete-btn').on 'click', ->
      type = $(this).closest('.cardBox').data('type')
      id = $(this).closest('.cardBox')[0].id.split("_")[1]
      if type is 'keep' || type is 'problem'
        App.board.delete_kpcard(id)
      else if type is 'try'
        App.board.delete_tcard(id)
      $("##{type_id}").remove()
        
  add_tcard: (card) ->
    type_id = "t_#{card.id}"

    addingCard = App.board.adding_tcard(card, type_id)

    $('#boardWrap').append addingCard
    addingCard.offset(top: card.y, left: card.x)
    $("##{type_id}").draggable({cancel: '.card-text'})
    
    date = new Date()
    year  = date.getFullYear()

    window.pickers[card.id] = new Pikaday(
      {
          field: document.getElementById("#{type_id}-datepicker-field"),
          trigger: document.getElementById("#{type_id}-datepicker"),
          ariaLabel: card.id,
          minDate: new Date(year - 2, 0, 1),
          maxDate: new Date(year + 2, 12, 31),
          yearRange: [year - 2, year + 2]
          onSelect: ((date) -> App.board.select_date(date, this._o.ariaLabel))
      })
    window.pickers[card.id].setDate(card.deadline)

    $("##{type_id}").on 'dragstop', ->
      title = $(this).find(".card-text").text()
      App.board.update_tcard($(this), title)
    $("##{type_id}-text").on 'blur', ->
      title = $(this).text()
      App.board.update_tcard($(this), title)
    $("##{type_id}-like").on 'click', ->
      likeClass = 'mdl-color-text--light-green-900'
      id = $(this)[0].dataset.id
      App.board.like_tcard(id)

      if $(this).children(".material-icons").hasClass(likeClass)
        $(this).children(".material-icons").removeClass(likeClass)
        $(this).next('span').removeClass(likeClass)
      else
        $(this).children(".material-icons").addClass(likeClass)
        $(this).next('span').addClass(likeClass)


  adding_kpcard: (card, type_id) ->
    isLiked = false
    if card.likes
      for like in card.likes
        isLiked = current_user.id is like.user_id
    else
      isLiked = false

    likeClass = ''
    if isLiked
      if card.card_type is 'keep'
        likeClass = 'mdl-color-text--blue-900'
      else if card.card_type is 'problem'
        likeClass = 'mdl-color-text--pink-900'
    else
      likeClass = 'kpter-color-text--white'

    likeNumClass = if card.card_type is 'keep' then 'mdl-color-text--blue-900' else 'mdl-color-text--pink-900'
    displayNum = if card.likes and card.likes.length > 0 then card.likes.length else ''

    addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp #{card.card_type} cardBox' id='#{type_id}' data-type='#{card.card_type}'>" +
        "<div class='mdl-card__title mdl-card--expand' id='#{type_id}'>" +
        "<p class='card-text' id='#{type_id}-text'>#{card.title}</p></div>" +
        "<div class='mdl-card__actions mdl-card--border'>" +
        "<div class='mdl-layout-spacer'></div>" +
        "<button id='#{type_id}-like' class='mdl-button mdl-js-button mdl-button--icon' data-id='#{card.id}' data-type='#{card.card_type}'><i class='material-icons #{likeClass}'>thumb_up</i></button>&nbsp<span class='#{likeClass}' style='vertical-align:text-bottom; font-size: 11px;'>#{displayNum}</span></div>" +
        "<div class='mdl-card__menu'><button class='mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect icon-white delete-btn'><i class='material-icons md-14'>close</i></button></div></div>")

  adding_tcard: (card, type_id) ->
    isLiked = false
    if card.likes
      for like in card.likes
        isLiked = current_user.id is like.user_id
    else
      isLiked = false

    likeClass = if isLiked then 'mdl-color-text--light-green-900' else 'kpter-color-text--white'
    displayNum = if card.likes and card.likes.length > 0 then card.likes.length else ''

    addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp try cardBox' id='#{type_id}' data-type='try'>" +
        "<div class='mdl-card__title mdl-card--expand' id='#{type_id}'>" +
        "<p class='card-text' style='height: 130px!important;' id='#{type_id}-text'>#{card.title}</p></div>" +
        "<div class='mdl-card__actions mdl-card--border'>" +
        "<div class='mdl-layout-spacer'></div>" +
        "<i class='material-icons'>account_circle</i>" +
        "<button id='#{type_id}-datepicker' class='mdl-button mdl-js-button mdl-button--icon' data-id='#{card.id}' data-type='#{card.card_type}'><i class='material-icons' id='datepicker'>event</i></button><input type='hidden' id='#{type_id}-datepicker-field'>" +
        "<button id='#{type_id}-like' class='mdl-button mdl-js-button mdl-button--icon' data-id='#{card.id}' data-type='#{card.card_type}'><i class='material-icons #{likeClass}'>thumb_up</i></button>&nbsp<span class='#{likeClass}' style='vertical-align:text-bottom; font-size: 11px;'>#{displayNum}</span></div>" +
        "<div class='mdl-card__menu'><button class='mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect icon-white delete-btn'><i class='material-icons md-14'>close</i></button></div></div>")
