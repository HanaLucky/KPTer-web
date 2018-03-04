# your test account
you = User.new(nickname: "nickname",
             email:  "email@example.com",
             password: "password")
you.skip_confirmation!
you.save!

# create a community & invite you
community = Community.create!(name: "Community Name")
you.invited(community)
you.join_in(community)

# other memberships
10.times do |n|
  user = User.new(nickname: "nickname-#{n}",
               email:  "email#{n}@example.com",
               password: "password")
  user.skip_confirmation!
  user.save!
  user.invited(community)
  # 1/10 memberships are inviting the community. (9/10 memberships are joining in the community.)
  if n % 10 != 0
    user.join_in(community)
  end
end

# create boards and k, p, t cards.
total_board = 20
total_card = User.all.length * 2 * 2

total_board.times do |i|
  board = Board.create!(name: "#{Time.current.ago((total_board - i).days).strftime('%Y-%m-%d')} KPT", community_id: community.id, created_at: Time.current.ago((total_board - i).days))
  total_card.times do |j|
    if j % 2 == 0
      KpCard.create!(card_type: KpCard.card_type.keep, title: "#{j} Keep Card.", board_id: board.id, owner_id: you.id, x: 150 * j, y: 145)
    end
    if j % 2 == 0
      KpCard.create!(card_type: KpCard.card_type.problem, title: "#{j} Problem Card.", board_id: board.id, owner_id: you.id, x: 150 * j, y: 445)
    end
    if j % 8 == 0
      TCard.create!(title: "#{j} Try Card", board_id: board.id, owner_id: you.id, deadline: Time.current.next_week(:friday), x: 150 * j, y: 745)
    end
  end
end

total_user = User.all.length

# assign task
total_card.times do |n|
  user = User.find((n % total_user)+1)
  tcard = TCard.find(n+1)
  tcard.assign(user)
end

# you are invited any other community.(not joining)
community = Community.create!(name: "Another Community Name")
you.invited(community)
