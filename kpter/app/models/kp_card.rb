class KpCard < ApplicationRecord
  extend Enumerize
  enumerize :card_type, in: [:keep, :problem]
  belongs_to :board

  after_create_commit { CardBroadcastJob.perform_later self }
end
