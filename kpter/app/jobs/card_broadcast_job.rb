class CardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(card)
    if card.class == KpCard
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "create", kpcard: render_kpcard(card), id: card.id, type: card.card_type
    elsif card.class == TCard
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "create", tcard: render_tcard(card), id: card.id, type: 'try'
    end
  end

  private

  def render_kpcard(card)
    ApplicationController.renderer.render(partial: 'cards/kpcard', locals: { kpcard: card })
  end

  def render_tcard(card)
    ApplicationController.renderer.render(partial: 'cards/tcard', locals: { tcard: card })
  end
end
