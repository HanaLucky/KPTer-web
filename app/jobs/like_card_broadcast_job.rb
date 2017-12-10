class LikeCardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id, type, method, num, board_id)
    ActionCable.server.broadcast "board_channel_#{board_id}", method: method, id: id, type: type, num: num
  end
end
