class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_kpcard(data)
    kpcard = KpCard.create! card_type: data['card_type'], title: data['title'], board_id: data['board_id'], x: data['x'], y: data['y']
    ActionCable.server.broadcast 'board_channel', kpcard: render_kpcard(kpcard)

  end

  def create_tcard(data)
    tcard = TCard.create! title: data['title'], user_id: current_user.id, board_id: data['board_id'], x: data['x'], y: data['y']
    ActionCable.server.broadcast 'board_channel', tcard: render_tcard(tcard)
  end

  private

  def render_kpcard(kp_card)
    ApplicationController.renderer.render(partial: 'cards/kpcard', locals: { kpcard: kp_card })
  end

  def render_tcard(t_card)
    ApplicationController.renderer.render(partial: 'cards/tcard', locals: { tcard: t_card })
  end

end
