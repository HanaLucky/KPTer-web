class TCard < ApplicationRecord
  extend Enumerize
  enumerize :status, in: [:open, :closed], default: :open
  belongs_to :board
end
