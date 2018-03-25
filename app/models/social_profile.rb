class SocialProfile < ApplicationRecord
  extend Enumerize
  enumerize :provider, in: [:google_oauth2]
  belongs_to :user
end
