module ApplicationHelper

  # avatar image url
  def avatar_url(user)
    if user
      unless user.avatar.file
        url = asset_path("noimages/profile.png")
      else
        url = "#{asset_path(user.avatar)}?#{user.lock_version}"
      end
    end
  end
end
