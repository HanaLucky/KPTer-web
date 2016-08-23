class TCard < ApplicationRecord
  enum status: { open: "open", done: "done" }
  belongs_to :board
end
