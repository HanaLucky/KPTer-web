class DeleteCardBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id, type, board_id)
    ActionCable.server.broadcast "board_channel_#{board_id}", method: "delete", id: id, type: type
  end
end
