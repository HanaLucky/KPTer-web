for card in kp_cards
  type_id = "kp_#{card.id}"
  addingCard = $("<div class='cardBox rounded #{card.card_type}' id='#{type_id}' data-type='#{card.card_type}'>#{card.title}</div>")

  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'blur', ->
    id = $(this)[0].id.split("_")[1]
    type = $(this)[0].dataset.type
    title = $(this).text()
    offset = $(this).offset()

    App.board.update_kpcard(id, title, offset.left, offset.top)

for card in t_cards
  type_id = "t_#{card.id}"
  addingCard = $("<div class='cardBox rounded try' id='#{type_id}' data-type='try'>#{card.title}</div>")

  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)

  $("##{type_id}").on 'blur', ->
    id = $(this)[0].id.split("_")[1]
    type = $(this)[0].dataset.type
    title = $(this).text()
    offset = $(this).offset()
    App.board.update_tcard(id, title, offset.left, offset.top)
