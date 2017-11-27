class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  mount_uploader :avatar, AvatarUploader
  has_many :community_users
  has_many :tcard_assignees
  has_many :t_card, :through => :tcard_assignees
  validates :email, presence: true, length: { maximum: 255 }
  validates :nickname, presence: true, length: { maximum: 255 }
  validate :avatar_size

  class << self
    def find_communities_with_user_id(user_id)
      User.includes([:community_users => [:community => [:boards => :t_cards]]])
        .references(:community_users)
        .where("community_users.user_id = ?", user_id)
        .map { |u| u.community_users }
        .flatten
        .sort_by!{ |v| [v[:status], v[:updated_at]] }
    end

    def find_tcards_with_user_id(user_id, status = TCard.status.open)
      User.joins([:tcard_assignees => :t_card])
        .includes([:tcard_assignees => :t_card])
        .where("tcard_assignees.user_id = ?", user_id)
        .where("t_cards.status = ?", status)
        .map { |u| u.tcard_assignees.map{ |ta| ta.t_card } }
        .flatten
        .sort_by!{ |t| [t[:deadline].nil? ? Date.new(9999, 12, 31) : t[:deadline], t[:id]]}  # 期限日の近い順 (同じ期限日内ではIDの昇順。未設定の場合(nil)は常に最後尾)
    end

    def find_all_tcards_with_user_id(user_id)
      User.joins([:tcard_assignees => :t_card])
        .includes([:tcard_assignees => :t_card])
        .where("tcard_assignees.user_id = ?", user_id)
        .map { |u| u.tcard_assignees.map{ |ta| ta.t_card } }
        .flatten
        .sort_by!{ |t| [t[:deadline].nil? ? Date.new(9999, 12, 31) : t[:deadline], t[:id]]}
    end

    def find_invitable_users(community, nickname = "", limit=20)
      User.where("
      id NOT IN (
        SELECT
          users.id
        FROM
          users
		      INNER JOIN community_users ON
			       users.id = community_users.user_id
             and community_users.community_id = ?
		  )
      AND confirmed_at IS NOT NULL
      AND nickname LIKE ? ", community.id, "%#{nickname}%")
      .limit(limit)
      .order("users.nickname, users.id")
    end
  end

  def joining?(community)
    CommunityUser.find_by(
      user_id: self.id,
      community_id: community.id,
      status: CommunityUser.status.joining
    ).present?
  end

  def invited(community)
    CommunityUser.create(
      community_id: community.id,
      user_id: self.id,
      status: CommunityUser.status.inviting
    )
  end

  def join_in(community)
    community_user = CommunityUser.find_by(
      community_id: community.id,
      user_id: self.id,
    )
    community_user.update(status: CommunityUser.status.joining)
  end

  def decline(community)
    community_user = CommunityUser.find_by(
      community_id: community.id,
      user_id: self.id,
    )
    community_user.delete
  end

  def leave(community)
    # leave community - delete from community_users entity
    community_user = CommunityUser.find_by(
      community_id: community.id,
      user_id: self.id,
    )
    community_user.delete

    # remove the charge - update t_cards entity, delete from tcard_assignees entity
    assigned_tasks_in_community = Community
      .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
      .references(:tcard_assignee => :user)
      .where('communities.id = ? and t_cards.user_id = ?', community.id, self.id)
      .map{ |community| community.boards.map{ |board| board.t_cards }}.flatten

    assigned_tasks_in_community.each do | t_card |
      t_card.update_attributes(user_id: nil)
      tcard_assignee = TcardAssignee.find_by(
        t_card_id: t_card.id,
        user_id: self.id
      )
      tcard_assignee.delete unless tcard_assignee.nil?
    end
  end

  def allowed_to_display?(community)
    CommunityUser.exists?(
      community_id: community.id,
      user_id: self.id
    )
  end

  def remember_me
    if Kpter::Application.config.remember_me_enable_by_default
      true
    else
      super
    end
  end

  # allow users to update their accounts without passwords
  # see. http://easyramble.com/user-account-update-without-password-on-devise.html
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  private
    # validate of upload image size
    def avatar_size
      if avatar.size > 5.megabytes
        errors.add(:avator, I18n.t('errors.messages.exceeded_limit_size', limit_size: "5MB"))
      end
    end
end