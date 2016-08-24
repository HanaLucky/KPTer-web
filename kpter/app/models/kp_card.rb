class KpCard < ApplicationRecord
  enum card_type: { keep: "keep", problem: "problem" }
  belongs_to :board
end
