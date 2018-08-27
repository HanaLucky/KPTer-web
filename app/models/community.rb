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

  def top_of_assignees
    Community
    .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
    .references(:tcard_assignee => :user)
    .where('communities.id = ? and t_cards.status = ? and users.nickname is not null', self.id, TCard.status.open)
    .group('users.id, users.nickname')
    .order('count_tcard_assignees_id desc, users.id asc')
    .count('tcard_assignees.id')
  end

  def find_tcards(status=TCard.status.open)
    Community
    .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
    .references(:tcard_assignee => :user)
    .where('communities.id = ? and t_cards.status = ?', self.id, status)
    .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
    .sort_by!{ |v| [v[:deadline].nil? ? Date.new(9999, 12, 31) : v[:deadline], v[:id]]}  # 期限日の近い順 (同じ期限日内ではIDの昇順。未設定の場合(nil)は常に最後尾)
  end

  def find_users
    Community
    .joins(:community_users => :user)
    .includes(:community_users => :user)
    .where(id: self.id)
    .map{ |community| community.community_users}.flatten
    .sort_by!{ |v| [v[:status].reverse, v[:updated_at]] }    # 参加した順(IDの昇順)
  end

  def find_joining_users
    Community
    .joins(:community_users => :user)
    .includes(:community_users => :user)
    .where('communities.id = ? and community_users.status = ?', self.id, CommunityUser.status.joining)
    .map{ |community| community.community_users}.flatten
    .sort_by!{ |v| [v[:status].reverse, v[:updated_at]] }    # 参加した順(IDの昇順)
  end

  def rest_in_place
    ActiveRecord::Base.transaction do
      tcard_assignees = Community
        .includes([:boards => [:t_cards => :tcard_assignee]])
        .references([:boards => [:t_cards => :tcard_assignee]])
        .where(id: self.id, boards: { community_id: self.id })
        .map{ |community| community.boards.map{ |board| board.t_cards.map{ |t_card| t_card.tcard_assignee }}}.flatten
      TcardAssignee.delete(tcard_assignees)

      t_cards = Community
        .includes([:boards => :t_cards])
        .references([:boards => :t_cards])
        .where(id: self.id, boards: { community_id: self.id })
        .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten
      TCard.delete(t_cards)

      kp_cards = Community
        .includes([:boards => :kp_cards])
        .references([:boards => :kp_cards])
        .where(id: self.id, boards: { community_id: self.id })
        .map{ |community| community.boards.map{ |board| board.kp_cards }}.flatten
      KpCard.delete(kp_cards)

      memos = Community
        .includes([:boards => :memos])
        .references([:boards => :memos])
        .where(id: self.id, boards: { community_id: self.id })
        .map{ |community| community.boards.map{ |board| board.memos }}.flatten
      Memo.delete(memos)

      boards = Community
        .includes(:boards)
        .references(:boards)
        .where(id: self.id, boards: { community_id: self.id })
        .map{ |community| community.boards }.flatten
      Board.delete(boards)

      community_users = Community
        .includes(:community_users)
        .references(:community_users)
        .where(id: self.id)
        .map{ |community| community.community_users }.flatten
      CommunityUser.delete(community_users)

      self.delete
    end
  end

  # {
  # :top_of_assignees=>
  #   [{:name=>"nickname-1", :count=>5},
  #    {:name=>"nickname-2", :count=>4},
  #    {:name=>"nickname-3", :count=>4},
  #    {:name=>"nickname-4", :count=>4},
  #    {:name=>"nickname-5", :count=>4},
  #    {:name=>"others", :count=>22}]
  # }
  def find_top_of_assignees
    top5 = Community.find(self.id).top_of_assignees.first(5)
    others = Community.find(self.id).top_of_assignees.to_a.from(5)
    top_of_assignees = Array.new
    top5.each { |i, j|
      data = { name: i, count: j }
      top_of_assignees.push(data)
    }

    if others.length > 0
      data = { name: t('community.well_balanced.label.others'), count: others.map{ |a| a[1] }.sum }
      top_of_assignees.push(data)
    end

    Hash["top_of_assignees": top_of_assignees]
  end
end
