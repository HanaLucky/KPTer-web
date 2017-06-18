class CardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(card)
    if card.class == KpCard
      ActionCable.server.broadcast 'board_channel', kpcard: render_kpcard(card)
    elsif card.class == TCard
      ActionCable.server.broadcast 'board_channel', tcard: render_tcard(card)
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
