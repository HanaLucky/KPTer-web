for card in kp_cards
  type_id = "kp_#{card.id}"
  isLiked = false
  for like in card.likes
    isLiked = current_user.id is like.user_id

  likeClass = ''
  if isLiked
    if card.card_type is 'keep'
      likeClass = 'mdl-color-text--blue-900'
    else if card.card_type is 'problem'
      likeClass = 'mdl-color-text--pink-900'
  else
    likeClass = 'kpter-color-text--white'

  likeNumClass = if card.card_type is 'keep' then 'mdl-color-text--blue-900' else 'mdl-color-text--pink-900'
  displayNum = if card.likes.length > 0 then card.likes.length else ''

  addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp #{card.card_type} cardBox' id='#{type_id}' data-type='#{card.card_type}'>" +
    "<div class='mdl-card__title mdl-card--expand' id='#{type_id}'>" +
    "<p class='card-text' id='#{type_id}-text'>#{card.title}</p></div>" +
    "<div class='mdl-card__actions mdl-card--border'>" +
    "<div class='mdl-layout-spacer'></div>" +
    "<button id='#{type_id}-like' class='mdl-button mdl-js-button mdl-button--icon' data-id='#{card.id}' data-type='#{card.card_type}'><i class='material-icons #{likeClass}'>thumb_up</i></button>&nbsp<span class='#{likeClass}' style='vertical-align:text-bottom; font-size: 11px;'>#{displayNum}</span></div>" +
    "<div class='mdl-card__menu'><button class='mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect icon-white delete-btn'><i class='material-icons md-14'>close</i></button></div></div>")
  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'dragstop', ->
    title = $(this).find(".card-text").text()
    update_kpcard($(this), title)
  $("##{type_id}-text").on 'blur', ->
    title = $(this).text()
    update_kpcard($(this), title)
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


for card in t_cards
  type_id = "t_#{card.id}"

  isLiked = false
  for like in card.likes
    isLiked = current_user.id is like.user_id

  likeClass = if isLiked then 'mdl-color-text--light-green-900' else 'kpter-color-text--white'
  displayNum = if card.likes.length > 0 then card.likes.length else ''

  addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp try cardBox' id='#{type_id}' data-type='try'>" +
    "<div class='mdl-card__title mdl-card--expand' id='#{type_id}'>" +
    "<p class='card-text' style='height: 130px!important;' id='#{type_id}-text'>#{card.title}</p></div>" +
    "<div class='mdl-card__actions mdl-card--border'>" +
    "<div class='mdl-layout-spacer'></div>" +
    "<i class='material-icons'>account_circle</i>" +
    "<i class='material-icons'>event</i>" +
    "<button id='#{type_id}-like' class='mdl-button mdl-js-button mdl-button--icon' data-id='#{card.id}' data-type='#{card.card_type}'><i class='material-icons #{likeClass}'>thumb_up</i></button>&nbsp<span class='#{likeClass}' style='vertical-align:text-bottom; font-size: 11px;'>#{displayNum}</span></div>" +
    "<div class='mdl-card__menu'><button class='mdl-button mdl-button--icon mdl-js-button mdl-js-ripple-effect icon-white delete-btn'><i class='material-icons md-14'>close</i></button></div></div>")

  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'dragstop', ->
    title = $(this).find(".card-text").text()
    update_tcard($(this), title)
  $("##{type_id}-text").on 'blur', ->
    title = $(this).text()
    update_tcard($(this), title)
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



# update card
update_kpcard = (_this, title) ->
  id = _this[0].id.split("_")[1]
  type = _this[0].dataset.type
  offset = _this.offset()
  App.board.update_kpcard(id, title, offset.left, offset.top)
  return

update_tcard = (_this, title) ->
  id = _this[0].id.split("_")[1]
  type = _this[0].dataset.type
  offset = _this.offset()
  App.board.update_tcard(id, title, offset.left, offset.top)
  return
