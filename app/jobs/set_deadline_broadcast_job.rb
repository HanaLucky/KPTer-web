class SetDeadlineBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id, deadline, board_id)
    ActionCable.server.broadcast "board_channel_#{board_id}", method: "set_deadline", id: id, deadline: deadline, from_server: true
  end
end
