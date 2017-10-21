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

  def t_cards_count(community)
    t_card_count = 0
    community.boards.each do | board |
      t_card_count += board.t_cards.count
    end
    return t_card_count unless t_card_count == 0
  end
end
