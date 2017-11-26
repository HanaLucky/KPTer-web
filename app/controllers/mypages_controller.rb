class MypagesController < ApplicationController
  before_action :authenticate_user!, :side_column, only: [:show]

  def show
    @all_tcards = User.find_tcards_with_user_id(current_user.id)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page]).per(5)
    @community = Community.new
  end

  def toggle
    render nothing: true
    all_tcards = User.find_all_tcards_with_user_id(current_user.id)
    param_id = params[:id].to_i
    if param_id > 0 && all_tcards.map{ |tc| tc.id }.include?(param_id)
      TCard.update_status(param_id)
    end
  end

  def refresh_tasks
    param_status = params[:status]
    status = param_status == TCard.status.open || param_status == TCard.status.closed ?  param_status : TCard.status.open
    @all_tcards = User.find_tcards_with_user_id(current_user.id, status)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page]).per(5)
    @status = status
  end
end
