class TCardsController < ApplicationController
  before_action :authenticate_user!, :exists_task?, :belongs_to?, :side_column, only: [:edit, :update]

  def edit
    @task = TCard.find(params[:id])
    @community_users = @task.board.community.find_joining_users
    respond_to do |format|
      format.js { render template: "t_cards/_modal_edit", :locals => {:task => @task, :community_users => @community_users, chaindata: params[:chaindata]} }
    end
  end

  def update
    t_card = TCard.find(params[:id])
    # 担当者に変更がある場合だけ
    unless t_card.try(:user).try(:id).to_s == params[:tcard_assignee][:user_id]
      if params[:tcard_assignee][:user_id].blank?
        # 担当者を外す
        t_card.remove_assign
      else
        # 他の人にアサイン
        user = User.find_by(id: params[:tcard_assignee][:user_id])
        t_card.assign(user)
      end
    end

    top_of_assignees = t_card.board.community.find_top_of_assignees
    labels = top_of_assignees[:top_of_assignees].map{|ta| ta[:name]}
    data = top_of_assignees[:top_of_assignees].map{|ta| ta[:count]}

    if t_card.update_attributes(t_card_params) then
      respond_to do |format|
        flash.now[:notice] = t('t_card.update.success')
        format.js { render template: "t_cards/_t_card", :locals => {t_card: TCard.find(params[:id]), title: t('community.well_balanced.title'), labels: labels.to_json.html_safe, data: data, chaindata: params[:chaindata]} }
      end
    else
      flash.now[:notice] = t('t_card.update.failure')
    end

  end

  private
    def t_card_params
      params.require(:t_card).permit(:id, :title, :detail, :deadline, :status)
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
