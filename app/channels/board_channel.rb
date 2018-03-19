class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel_#{params[:board_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_kpcard(data)
    kpcard = KpCard.create! card_type: data['card_type'], title: data['title'], board_id: data['board_id'], owner_id: current_user.id, x: data['x'], y: data['y']
  end

  def create_tcard(data)
    tcard = TCard.create! title: data['title'], board_id: data['board_id'], owner_id: current_user.id, x: data['x'], y: data['y']
  end

  def create_memo(data)
    memo = Memo.create! contents: data['contents'], board_id: data['board_id'], x: data['x'], y: data['y']
  end

  def update_kpcard(data)
    id = data['id'].to_i
    card = KpCard.find(id)
    card.update! title: data['title'], x: data['x'], y: data['y']
  end

  def update_tcard(data)
    card = TCard.find(data['id'])
    card.update! title: data['title'], x: data['x'], y: data['y']
  end

  def update_memo(data)
    card = Memo.find(data['id'])
    card.update! contents: data['contents'], x: data['x'], y: data['y']
  end

  def delete_kpcard(data)
    card = KpCard.find(data['id'])
    DeleteCardBroadcastJob.perform_later card.id, card.card_type, card.board_id
    card.delete
  end

  def delete_tcard(data)
    card = TCard.find(data['id'])
    DeleteCardBroadcastJob.perform_later card.id, 'try', card.board_id
    card.delete
  end

  def delete_memo(data)
    card = Memo.find(data['id'])
    DeleteCardBroadcastJob.perform_later card.id, 'memo', card.board_id
    card.delete
  end

  def like_kpcard(data)
    card = KpCard.find(data['id'])
    my_likes = card.likes.where("likes.user_id=?", current_user.id)
    if my_likes.present?
      my_likes.delete_all
      num = card.likes.count
      LikeCardBroadcastJob.perform_later card.id, card.card_type, "dislike", num, card.board_id
    else
      Like.create! likable_type: card.class, likable_id: card.id, user_id: current_user.id
      num = card.likes.count
      LikeCardBroadcastJob.perform_later card.id, card.card_type, "like", num, card.board_id
    end
  end

  def like_tcard(data)
    card = TCard.find(data['id'])
    my_likes = card.likes.where("likes.user_id=?", current_user.id)
    if my_likes.present?
      my_likes.delete_all
      num = card.likes.count
      LikeCardBroadcastJob.perform_later card.id, "try", "dislike", num, card.board_id
    else
      Like.create! likable_type: card.class, likable_id: card.id, user_id: current_user.id
      num = card.likes.count
      LikeCardBroadcastJob.perform_later card.id, "try", "like", num, card.board_id
    end
  end

  def set_deadline(data)
    card = TCard.find(data['id'])
    deadline = data['deadline'].in_time_zone
    card.update! deadline: deadline
    SetDeadlineBroadcastJob.perform_later card.id, deadline.to_s, card.board_id
  end
end
