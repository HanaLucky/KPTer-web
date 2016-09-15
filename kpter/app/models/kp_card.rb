class KpCard < ApplicationRecord
  extend Enumerize
  enumerize :card_type, in: [:keep, :problem]
  belongs_to :board
end
