class UpdateCardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(card)
    if card.class == KpCard
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "update",  kpcard: card
    elsif card.class == TCard
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "update",  tcard: card
    end
  end
end
