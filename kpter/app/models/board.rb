class Board < ApplicationRecord
  belongs_to :community
  has_many :kp_cards
  has_many :t_cards
  has_many :memos
end
