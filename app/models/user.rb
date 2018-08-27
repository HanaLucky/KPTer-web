require "google/cloud/storage"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :community_users
  has_many :tcard_assignees
  has_many :t_card, :through => :tcard_assignees
  has_many :t_cards_of_owner, :class_name => 'TCard', :foreign_key => 'owner_id'
  has_many :kp_cards_of_owner, :class_name => 'KpCard', :foreign_key => 'owner_id'
  has_many :social_profiles, dependent: :destroy
  validates :email, presence: true, length: { maximum: 255 }
  validates :nickname, presence: true, length: { maximum: 255 }
  validate :cover_image_size

  def self.storage_bucket
    if Rails.env.production?
      @storage_bucket ||= begin
        config = Rails.application.config.x.settings
        storage = Google::Cloud::Storage.new
        storage.bucket config["gcs_bucket"], skip_lookup: true
      end
    end
  end

  attr_accessor :cover_image

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
    ActiveRecord::Base.transaction do
      # leave community - delete from community_users entity
      community_user = CommunityUser.find_by(
        community_id: community.id,
        user_id: self.id,
      )
      community_user.delete

      # remove the charge - delete from tcard_assignees entity
      tcard_assignees = Community
        .includes([:boards => [:t_cards => [:tcard_assignee => :user]]])
        .references(:tcard_assignee => :user)
        .where('communities.id = ? and tcard_assignees.user_id = ?', community.id, self.id)
        .map{ |community| community.boards.map{ |board| board.t_cards.map{ |tcard| tcard.tcard_assignee } } }.flatten

      TcardAssignee.delete(tcard_assignees) unless tcard_assignees.nil?
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
    else
      # パスワードが設定されるタイミングで、oauthのみの登録ではなくす
      params = params.merge(only_oauth_registration: false)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  def social_profile(provider)
    social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end

  def authenticated?(provider)
    self.social_profiles.exists?(provider: provider)
  end

  def disconnect(provider)
    self.social_profiles.where(provider: provider).delete_all
  end

  def inactive
    ActiveRecord::Base.transaction do
      # K, P, Tカード所有者でなくす
      TCard.where('owner_id = ?', self.id).update_all(:owner_id => nil)
      KpCard.where('owner_id = ?', self.id).update_all(:owner_id => nil)
      # タスクの担当者から外す
      tcard_assignees = TcardAssignee.where(user_id: self.id).delete_all
      # like差し引く
      likes = Like.where(user_id: self.id).delete_all
      # 全コミュニティから抜ける
      community_users = CommunityUser.where(user_id: self.id).delete_all
      # ソーシャル連携を削除する
      social_profiles = SocialProfile.where(user_id: self.id).delete_all
    end
  end

  private
    # validate of upload image size
    def cover_image_size
      unless cover_image.nil?
        if cover_image.size > 3.megabytes
          errors.add(:avator, I18n.t('errors.messages.exceeded_limit_size', limit_size: "3MB"))
        end
      end
    end

    after_create :upload_image, if: :cover_image
    def upload_image
      avatar_path = "uploads/user/avatar/#{id}"
      ext = File.extname(cover_image.original_filename)
      cover_image.original_filename = cover_image.original_filename.unpack("H*")[0] + ext
      if Rails.env.production?
        file = User.storage_bucket.create_file \
          cover_image.tempfile,
          "#{avatar_path}/#{cover_image.original_filename}",
          content_type: cover_image.content_type,
          acl: "public"
        avatar_url = file.public_url
      else
        fs_directory = Rails.root.join('public', avatar_path)
        FileUtils.mkdir_p(fs_directory) unless FileTest.exist?(fs_directory)
        File.open("#{fs_directory}/#{cover_image.original_filename}", 'w+b') do |fp|
          fp.write(cover_image.tempfile.read)
        end
        avatar_url = "/#{avatar_path}/#{cover_image.original_filename}"
      end
      update_columns avatar: avatar_url
    end

    before_destroy :delete_image, if: :avatar
    def delete_image
      if Rails.env.production?
        image_uri = URI.parse URI.encode avatar
        if "#{image_uri.host}/#{User.storage_bucket.name}" == "storage.googleapis.com/#{User.storage_bucket.name}"
          # Remove leading forward slash from image path
          # The result will be the image key, eg. "cover_images/:id/:filename"
          image_path = image_uri.path.sub("/#{User.storage_bucket.name}/", "")
          file = User.storage_bucket.file image_path
          file.delete
        end
      else
        # 元のファイルを削除する
        avatar_file = 'public' + self.avatar
        FileUtils.rm_r(avatar_file) if FileTest.exist?(avatar_file)
      end
    end

    before_update :update_image, if: :cover_image
    def update_image
      delete_image if avatar?
      upload_image
    end
end
