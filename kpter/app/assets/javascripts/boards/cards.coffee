for card in cards
  addingCard = $("<div class='cardBox rounded #{card.card_type}' id='#{card.id}' data-type='#{card.card_type}'>#{card.title}</div>")
  $('#boardWrap').append addingCard
  addingCard.offset(top: card.y, left: card.x)
