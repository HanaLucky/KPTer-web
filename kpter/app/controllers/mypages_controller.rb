class MypagesController < ApplicationController
  def show
    @communities = User.find_communities_with_user_id(current_user.id)
    @all_tcards = User.find_tcards_with_user_id(current_user.id)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page])
  end

  def toggle
      render nothing: true
      TCard.update_status(params[:id])
  end

  def refresh_tasks
    @all_tcards = User.find_tcards_with_user_id(current_user.id, params[:status])
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page])
  end

end
