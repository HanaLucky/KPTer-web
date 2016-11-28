class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  has_many :community_users
  has_many :tcard_assignees
  has_many :t_card, :through => :tcard_assignees

  class << self
    def find_communities_with_user_id(user_id)
      User.includes([{ :community_users => :community }])
        .references(:community_users).order("communities.id DESC")
        .where("community_users.user_id = ?", user_id)
        .map { |u| u.community_users.map { |cu| cu.community }}
        .flatten
    end

    def find_tcards_with_user_id(user_id, status = TCard.status.open)
      User.joins([:tcard_assignees => :t_card])
        .includes([:tcard_assignees => :t_card])
        .where("tcard_assignees.user_id = ?", user_id)
        .where("t_cards.status = ?", status)
        .map { |u| u.tcard_assignees.map{ |ta| ta.t_card } }
        .flatten
        .sort_by!{ |t| [t[:deadline], t[:id]]}
    end

    def find_all_tcards_with_user_id(user_id)
      User.joins([:tcard_assignees => :t_card])
        .includes([:tcard_assignees => :t_card])
        .where("tcard_assignees.user_id = ?", user_id)
        .map { |u| u.tcard_assignees.map{ |ta| ta.t_card } }
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
