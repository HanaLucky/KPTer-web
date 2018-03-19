class CardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(card)
    if card.class == KpCard
      card = KpCard.includes(:owner).references(:owner).find(card.id)
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "create", kpcard: card.to_json(include: [:owner]), id: card.id, type: card.card_type
    elsif card.class == TCard
      card = TCard.includes(:owner).references(:owner).find(card.id)
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "create", tcard: card.to_json(include: [:owner]), id: card.id, type: 'try'
    elsif card.class == Memo
      card = Memo.find(card.id)
      ActionCable.server.broadcast "board_channel_#{card.board_id}", method: "create", memo: card.to_json, id: card.id, type: 'memo'
    end
  end

  private

  def render_kpcard(card)
    num = card.likes.count
    num = "" if num <= 0
    ApplicationController.renderer.render(partial: 'cards/kpcard', locals: { kpcard: card, display_num: num })
  end

  def render_tcard(card)
    num = card.likes.count
    num = "" if num <= 0
    ApplicationController.renderer.render(partial: 'cards/tcard', locals: { tcard: card, display_num: num })
  end
end
