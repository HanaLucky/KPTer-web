module ApplicationHelper

  # avatar image url
  def avatar_url(user)
    unless user
      if user.avatar.file.nil?
        url = asset_path("noimages/profile_#{user.id % 3}.png")
      else
        url = "#{asset_path(user.avatar)}?#{user.lock_version}"
      end
    end
  end
end
