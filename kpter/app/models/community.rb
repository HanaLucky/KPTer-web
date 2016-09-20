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

end
