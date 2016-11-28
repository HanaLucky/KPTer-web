class Community < ApplicationRecord
  has_many :community_users
  has_many :boards

  validates_length_of :name, in: 0..32

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
    .joins([:boards => [:t_cards => [:tcard_assignee => :user]]])
    .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
    .where('communities.id = ? and t_cards.status = ?', self.id, status)
    .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
    .sort_by!{ |v| [v[:deadline], v[:id]]}    # 期限日の近い順 (同じ期限日内ではIDの昇順)
  end

  def withdraw(user)
    @community_user = CommunityUser.find_by(community_id: self.id, user_id: user.id)
    if @community_user.nil? then
      return
    end
    @community_user.destroy
  end

  def find_users
    Community
    .joins(:community_users => :user)
    .includes(:community_users => :user)
    .where(id: self.id)
    .map{ |community| community.community_users}.flatten
    .sort_by!{ |v| v[:id] }    # 参加した順(IDの昇順)
    .map{ |cu| cu.user}
  end
end
