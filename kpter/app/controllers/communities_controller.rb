class CommunitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :exists_community?
  before_action :allowed_to_display?

  def show
    # TODO: コミュニティページ表示中にコミュニティから除名させられた場合の処理
    # https://github.com/HanaLucky/KPTer-web/issues/96
    @community = Community.find(params[:id])
    @communities = User.find_communities_with_user_id(current_user.id)
    @all_boards = @community.find_boards
    @boards = Kaminari.paginate_array(@all_boards).page(params[:page]).per(5)
    @all_tcards = @community.find_tcards
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page]).per(10)
    @attendees = @community.find_users
  end

  def toggle
    render nothing: true
    TCard.update_status(params[:t_card_id])
  end

  def refresh_tasks
    status = params[:status]
    status ||= TCard.status.open
    @community = Community.find(params[:id])
    @all_tcards = @community.find_tcards(status)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page])
  end

  def update
    @community = Community.find(params[:id])

    respond_to do |format|
      if @community.update_attributes(name: params[:community][:name])
        format.html { redirect_to @community, notice: 'Community name was successfully updated.' }
        format.json { head :no_content } # 204 No Content
      else
        format.json { render json: {message: @community.errors.full_messages.first}, status: :unprocessable_entity }
      end
    end
  end

  def invitable_users
    @community = Community.find(params[:id])
    @invitable_users = User.find_invitable_users(@community)
  end

  def invite
    if params[:community].nil?
      # フロントJSで未選択の場合はボタンdisableにするが、それでもユーザー未指定でリクエストされた場合は、画面をリフレッシュする(chatwork理論)
      errors.add(:avator, t('commynity.invitation.failure'))
      redirect_to :action => :show and return
    end

    @users = User.where(id: params[:community][:user_ids])
    @community = Community.find(params[:id])
    @users.each{ |user|
      unless user.joining?(@community)
        user.invited(@community)
      end
    }

    flash[:notice] = t('commynity.invitation.success', users: @users.map(&:nickname).join(', '))
    redirect_to :action => :show
  end

  def accept
    community = Community.find(params[:id])
    current_user.join_in(community)
    flash[:notice] = t('commynity.invitation.accept')
    redirect_to :action => :show
  end

  def decline
    community = Community.find(params[:id])
    current_user.decline(community)
    flash[:notice] = t('commynity.invitation.decline')
    redirect_to :controller => :mypages, :action => :show
  end

  def leave
    community = Community.find(params[:id])
    current_user.leave(community)
    flash[:notice] = t('commynity.leave')
    redirect_to :controller => :mypages, :action => :show
  end

  def destroy
    community = Community.find(params[:id])
    community.rest_in_place
    flash[:notice] = t('commynity.destroyed')
    redirect_to :controller => :mypages, :action => :show
  end

  private
    def exists_community?
      # if community does not exists, raise RecordNotFound error
      Community.find(params[:id])
    end

    def allowed_to_display?
      community = Community.find(params[:id])
      unless current_user.allowed_to_display?(community)
        raise Forbidden
      end
    end
end
