class MypagesController < ApplicationController
  def show
    @communities = User.find_communities_with_user_id(current_user.id)
    @t_cards = User.find_tcards_with_user_id(current_user.id)
  end

  def toggle
      render nothing: true
      TCard.update_status(params[:id])
  end

  def refresh_tasks
    @t_cards = User.find_tcards_with_user_id(current_user.id, params[:status])
  end

end
