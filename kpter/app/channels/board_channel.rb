class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_tcard(data)
    p "******title*******"
    p data['title']
    p "***board-id***"
    p data['board_id']
    TCard.create! title: data['title'], board_id: data['board_id'], x: data['x'], y: data['y']
  end
end
