class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  has_many :community_users
  class << self
    def find_communities_with_user_id(user_id)
      Array(User.includes([{ :community_users => :community }])
        .references(:community_users).order("communities.id DESC").find(user_id)
        ).map { |u| u.community_users.map { |cu| cu.community }}.flatten
    end

    def find_tcards_with_user_id(user_id: user_id, status: "Open")
      Array(User.includes([:community_users => [ :community => [ :boards => [ :t_cards ]]]])
        .references(:community_users)
        .order("communities.id DESC").where("t_cards.status = ?", status)
        .find(user_id)
        ).map { |u| u.community_users.map { |cu| cu.community.boards.map { |b| b.t_cards } }}
        .flatten
    end
  end

end
