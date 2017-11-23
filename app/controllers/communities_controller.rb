class CommunitiesController < ApplicationController
  before_action :authenticate_user!, :exists_community?, :allowed_to_display?, :side_column, only: [:show]

  def show
    # TODO: コミュニティページ表示中にコミュニティから除名させられた場合の処理
    # https://github.com/HanaLucky/KPTer-web/issues/96
    @community = Community.find(params[:id])
    @all_boards = @community.find_boards
    @boards = Kaminari.paginate_array(@all_boards).page(params[:page]).per(5)
    @all_tcards = @community.find_tcards
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page]).per(5)
    @top_of_assignees = @community.top_of_assignees.first(5)
    @invitable_users = User.find_invitable_users(@community)
  end

  def toggle
    TCard.update_status(params[:t_card_id])

    respond_to do |format|
      top_of_assignees = Community.find(params[:id]).top_of_assignees.first(5)
      other_assignees = Community.find(params[:id]).top_of_assignees.to_a.from(5)
      other_label = 'others'
      other_data = other_assignees.map{|a| a[1]}.sum
      labels = Array.new
      data = Array.new
      top_of_assignees.each {|i, j|
        labels.push(i)
        data.push(j)
      }
      labels.push(other_label)
      data.push(other_data)
      format.json { render json: {labels: labels, data: data}}
    end
  end

  def refresh_tasks
    status = params[:status]
    status ||= TCard.status.open
    @community = Community.find(params[:id])
    @all_tcards = @community.find_tcards(status)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page]).per(5)
    @status = status
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
    @invitable_users = User.find_invitable_users(@community, params[:q])
    respond_to do |format|
      format.js
      format.json { render json: @invitable_users.as_json(only: ['id', 'nickname']) }  # セキュリティ的に必要最小限をレスポンスする
    end
  end

  def members
    @members = Community.find(params[:id]).find_users
  end

  def invite
    if params[:id].nil?
      # フロントJSで未選択の場合はボタンdisableにするが、それでもユーザー未指定でリクエストされた場合は、画面をリフレッシュする(chatwork理論)
      flash[:notice] = t('commynity.invitation.failure')
      redirect_to :action => :show and return
    end

    @users = User.where(id: params[:user][:ids])
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

  def remove
    community = Community.find(params[:id])
    user = User.find(params[:user_id])
    community.withdraw(user)
    flash[:notice] = t('commynity.remove', nickname: user.nickname)
    redirect_to :action => :show and return
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
