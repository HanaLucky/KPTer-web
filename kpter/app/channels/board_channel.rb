class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_kpcard(data)
    kpcard = KpCard.create! card_type: data['card_type'], title: data['title'], board_id: data['board_id'], x: data['x'], y: data['y']
  end

  def create_tcard(data)
    tcard = TCard.create! title: data['title'], user_id: current_user.id, board_id: data['board_id'], x: data['x'], y: data['y']
  end

end
