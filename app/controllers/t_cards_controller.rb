class TCardsController < ApplicationController
  before_action :authenticate_user!, :exists_task?, :belongs_to?, :side_column, only: [:edit, :update]

  def edit
    # TODO 所属しているコミュニティのタスクだけみれたり編集できたり。
    @task = TCard.find(params[:id])
    @community_users = @task.board.community.find_users
    respond_to do |format|
      format.js { render template: "t_cards/_modal_edit", :locals => {:task => @task, :community_users => @community_users, chaindata: params[:chaindata]} }
    end
  end

  def update
    t_card = TCard.find(params[:id])
    # 担当者に変更がある場合だけ
    unless t_card.user_id.to_s == t_cart_params[:user_id]
      if t_cart_params[:user_id].blank?
        # 担当者を外す
        t_card.remove_assign
      else
        # 他の人にアサイン
        user = User.find_by(id: t_cart_params[:user_id])
        t_card.assign(user)
      end
    end

    if t_card.update_attributes(t_cart_params) then
      respond_to do |format|
        format.js { render template: "t_cards/_t_card", :locals => {t_card: TCard.find(params[:id]), chaindata: params[:chaindata]} }
      end
    else
      # TODO error message
    end
  end

  private
    def t_cart_params
      params.require(:t_card).permit(:id, :title, :detail, :user_id, :deadline, :status)
    end

    def exists_task?
      # if task does not exists, raise RecordNotFound error
      TCard.find(params[:id])
    end

    def belongs_to?
      tcard = TCard.find(params[:id])
      unless current_user.joining?(tcard.board.community)
        raise Forbidden
      end
    end
end
