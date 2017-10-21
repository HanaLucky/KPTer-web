class Board < ApplicationRecord
  belongs_to :community
  has_many :kp_cards
  has_many :t_cards
  has_many :memos
  validates_length_of :name, in: 1..255
end
