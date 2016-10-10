class MypagesController < ApplicationController
  def show
    @communities = User.find_communities_with_user_id(current_user.id)
    @t_cards = User.find_tcards_with_user_id(current_user.id)
  end

  def toggle
      render nothing: true
      @t_card = TCard.find(params[:id])
      # statusの値をひっくり返す
      @t_card.status = @t_card.status.open? ? TCard.status.closed : TCard.status.open
      @t_card.save
  end

  def refresh_tasks
    @t_cards = User.find_tcards_with_user_id(current_user.id, params[:status])
  end

end
