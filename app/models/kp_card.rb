class KpCard < ApplicationRecord
  extend Enumerize
  enumerize :card_type, in: [:keep, :problem]
  belongs_to :board
  has_many :likes, :as => :likable

  after_create_commit { CardBroadcastJob.perform_later self }
  after_update_commit { UpdateCardBroadcastJob.perform_later self }
end
