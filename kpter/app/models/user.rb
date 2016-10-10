class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  has_many :community_users

  class << self
    def find_communities_with_user_id(user_id)
      User.includes([{ :community_users => :community }])
        .references(:community_users).order("communities.id DESC")
        .where("community_users.user_id = ?", user_id)
        .map { |u| u.community_users.map { |cu| cu.community }}
        .flatten
    end

    def find_tcards_with_user_id(user_id, status = TCard.status.open)
      User.joins([:community_users => [ :community => [ :boards => [ :t_cards ]]]])
        .includes([:community_users => [ :community => [ :boards => [ :t_cards ]]]])
        .where("t_cards.status = ?", status)
        .where("t_cards.user_id = ?", user_id)
        .map { |u| u.community_users.map { |cu| cu.community.boards.map { |b| b.t_cards } }}
        .flatten
        .sort_by!{ |t| [t[:deadline], t[:id]]}
    end
  end

  def joining?(community)
    CommunityUser.where("user_id = ? and community_id = ?", id, community.id).present?
  end

  def join_in(community)
    CommunityUser.create(
      community_id: community.id,
      user_id: self.id
    )
  end

end
