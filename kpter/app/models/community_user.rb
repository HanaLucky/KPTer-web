class CommunityUser < ApplicationRecord
  belongs_to :community
  belongs_to :user

  validates :user_id, :uniqueness => {:scope => :community_id, :message => I18n.t('activerecord.errors.models.user.attributes.user_id.taken')}
end
