class BoardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "board_channel_#{params[:board_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def create_kpcard(data)
    kpcard = KpCard.create! card_type: data['card_type'], title: data['title'], board_id: data['board_id'], x: data['x'], y: data['y']
  end

  def create_tcard(data)
    tcard = TCard.create! title: data['title'], board_id: data['board_id'], x: data['x'], y: data['y']
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
end
