class KpCard < ApplicationRecord
  extend Enumerize
  enumerize :card_type, in: [:keep, :problem]
  belongs_to :board
  belongs_to :owner, :class_name => 'User'
  has_many :likes, :as => :likable, dependent: :delete_all

  after_create_commit { CardBroadcastJob.perform_later self }
  after_update_commit { UpdateCardBroadcastJob.perform_later self }
end
