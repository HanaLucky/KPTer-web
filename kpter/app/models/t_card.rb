class TCard < ApplicationRecord
  extend Enumerize
  enumerize :status, in: [:open, :closed], default: :open
  belongs_to :board

  class << self
    def update_status(t_card_id)
      @t_card = TCard.find(t_card_id)
      # statusの値をひっくり返す
      @t_card.status = @t_card.status.open? ? TCard.status.closed : TCard.status.open
      @t_card.save
    end
  end
end
