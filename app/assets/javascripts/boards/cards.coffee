for card in kp_cards
  type_id = "kp_#{card.id}"
  addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp #{card.card_type} cardBox' id='#{type_id}' data-type='#{card.card_type}'>" +
    "<div class='mdl-card__title mdl-card--expand'>" +
    "<p class='card-text'>#{card.title}</p></div></div>")
  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'blur', ->
    id = $(this)[0].id.split("_")[1]
    type = $(this)[0].dataset.type
    title = $(this).find('h4').text()
    offset = $(this).offset()

    App.board.update_kpcard(id, title, offset.left, offset.top)

for card in t_cards
  type_id = "t_#{card.id}"
  addingCard = $("<div class='kpter-card-event mdl-card mdl-shadow--2dp try cardBox' id='#{type_id}' data-type='try'>" +
    "<div class='mdl-card__title mdl-card--expand'>" +
    "<p class='card-text' style='height: 130px!important;'>#{card.title}</p></div>" +
    "<div class='mdl-card__actions mdl-card--border'>" +
    "<a class='mdl-button mdl-button--colored mdl-js-button mdl-js-ripple-effect'>Assignees</a>" +
    "<div class='mdl-layout-spacer'></div>" +
    "<i class='material-icons'>event</i></div></div>")

  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'blur', ->
    id = $(this)[0].id.split("_")[1]
    type = $(this)[0].dataset.type
    title = $(this).find('h4').text()
    offset = $(this).offset()
    App.board.update_tcard(id, title, offset.left, offset.top)
