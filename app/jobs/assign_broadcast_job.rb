class AssignBroadcastJob < ApplicationJob
  queue_as :default

  def perform(id, user_id, board_id)
    ActionCable.server.broadcast "board_channel_#{board_id}", method: "set_assignee", id: id, user_id: user_id
  end
end
