class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_card(data)
    ActionCable.server.broadcast 'board_channel', title: data['title']
  end
end
