class TCard < ApplicationRecord
  enum status: { open: "Open", closed: "Closed" }
  belongs_to :board
end
