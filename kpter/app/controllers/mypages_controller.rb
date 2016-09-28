class MypagesController < ApplicationController
  def show
    @communities = User.find_communities_with_user_id(current_user.id)
    @t_cards = User.find_tcards_with_user_id(current_user.id)
  end
end
