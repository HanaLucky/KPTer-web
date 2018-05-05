module ApplicationHelper

  # avatar image url
  def avatar_url(user)
    if user
      unless user.avatar
        url = asset_path("noimages/profile.png")
      else
        url = "#{asset_path(user.avatar)}?#{user.lock_version}"
      end
    end
  end

  def t_cards_count(community)
    t_card_count = 0
    community.boards.each do |board|
      board.t_cards.each do |t_catd|
        t_card_count += 1 if t_catd.status.open?
      end
    end
    return t_card_count unless t_card_count == 0
  end
end
