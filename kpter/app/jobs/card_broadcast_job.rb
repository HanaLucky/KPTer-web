class CardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(t_card)
    ActionCable.server.broadcast 'board_channel', tcard: render_tcard(t_card)
  end

  private
    def render_tcard(t_card)
      ApplicationController.renderer.render(partial: 'cards/tcard', locals: { tcard: t_card })
    end
end
