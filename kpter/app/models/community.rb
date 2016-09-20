class Community < ApplicationRecord
  has_many :community_users
  has_many :boards

  def find_boards
    Community
    .includes(:boards)
    .joins(:boards)
    .where(id: self.id)
    .map{ |community| community.boards }.flatten
    .sort_by!{ |v| v[:id] }.reverse    # 作成された順(IDの降順)
  end

  def find_tcards(status=TCard.status.open)
    Community
    .joins(:boards => :t_cards)
    .includes(:boards => :t_cards)
    .where('communities.id = ? and t_cards.status = ?', self.id, status)
    .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
    .sort_by!{ |v| [v[:deadline], v[:id]]}    # 期限日の近い順 (同じ期限日内ではIDの昇順)
  end

end
