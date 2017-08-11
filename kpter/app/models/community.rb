class Community < ApplicationRecord
  has_many :community_users
  has_many :boards
  validates_length_of :name, in: 1..32

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
    .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
    .references(:tcard_assignee => :user)
    .where('communities.id = ? and t_cards.status = ?', self.id, status)
    .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
    .sort_by!{ |v| [v[:deadline].nil? ? Date.new(9999, 12, 31) : v[:deadline], v[:id]]}  # 期限日の近い順 (同じ期限日内ではIDの昇順。未設定の場合(nil)は常に最後尾)
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
    .sort_by!{ |v| [v[:status].reverse, v[:updated_at]] }    # 参加した順(IDの昇順)
  end

  def rest_in_place
    tcard_assignees = Community
      .includes([:boards => [:t_cards => :tcard_assignee]])
      .references([:boards => [:t_cards => :tcard_assignee]])
      .where(id: self.id, boards: { community_id: self.id })
      .map{ |community| community.boards.map{ |board| board.t_cards.map{ |t_card| t_card.tcard_assignee }}}.flatten
    TcardAssignee.destroy(tcard_assignees)

    t_cards = Community
      .includes([:boards => :t_cards])
      .references([:boards => :t_cards])
      .where(id: self.id, boards: { community_id: self.id })
      .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
    TCard.destroy(t_cards)

    kp_cards = Community
      .includes([:boards => :kp_cards])
      .references([:boards => :kp_cards])
      .where(id: self.id, boards: { community_id: self.id })
      .map{ |community| community.boards.map{ |board| board.kp_cards }}.flatten
    KpCard.destroy(kp_cards)

    memos = Community
      .includes([:boards => :memos])
      .references([:boards => :memos])
      .where(id: self.id, boards: { community_id: self.id })
      .map{ |community| community.boards.map{ |board| board.memos }}.flatten
    Memo.destroy(memos)

    boards = Community
      .includes(:boards)
      .references(:boards)
      .where(id: self.id, boards: { community_id: self.id })
      .map{ |community| community.boards }.flatten
    Board.destroy(boards)

    community_users = Community
      .includes(:community_users)
      .references(:community_users)
      .where(id: self.id)
      .map{ |community| community.community_users }.flatten
    CommunityUser.destroy(community_users)

    self.destroy
  end
end
