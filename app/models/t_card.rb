class TCard < ApplicationRecord
  extend Enumerize
  enumerize :status, in: [:open, :closed], default: :open
  belongs_to :board
  belongs_to :owner, :class_name => 'User'
  has_one :tcard_assignee
  has_one :user, :through => :tcard_assignee
  has_many :likes, :as => :likable, dependent: :delete_all

  after_create_commit { CardBroadcastJob.perform_later self }
  after_update_commit { UpdateCardBroadcastJob.perform_later self }

  class << self
    def update_status(t_card_id)
      @t_card = TCard.find(t_card_id)
      # statusの値をひっくり返す
      @t_card.status = @t_card.status.open? ? TCard.status.closed : TCard.status.open
      @t_card.save
    end
  end
end
