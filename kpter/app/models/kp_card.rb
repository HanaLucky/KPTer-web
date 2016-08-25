class KpCard < ApplicationRecord
  enum card_type: { keep: "Keep", problem: "Problem" }
  belongs_to :board
end
