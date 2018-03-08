class CommunitiesController < ApplicationController
  before_action :authenticate_user!, :exists_community?, :allowed_to_display?, :side_column, only: [:show]
  before_action :belongs_to?, except: [:show, :decline, :accept, :create]

  def create
    @community = Community.new(name: params[:name])
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @community.save
          @community_user = CommunityUser.new(
            user_id: current_user.id,
            community_id: @community.id,
            status: CommunityUser.status.joining
            )
          if @community_user.save
            format.html { redirect_to @community, notice: t('community.created') }
            format.json { render :show, status: :created, location: @community }
          else
            format.html { render :show }
          end
        else
          @error_message = @community.errors.full_messages.first
          format.html { redirect_to :back, alert: @error_message }
        end
      end
    end
  end

  def show
    @community = Community.find(params[:id])
    all_boards = @community.find_boards
    @boards = Kaminari.paginate_array(all_boards).page(params[:page]).per(5)
    all_tcards = @community.find_tcards
    @t_cards = Kaminari.paginate_array(all_tcards).page(params[:page]).per(5)
    @top_of_assignees = find_top_of_assignees(params[:id])
    @invitable_users = User.find_invitable_users(@community)
  end

  def toggle
    TCard.update_status(params[:t_card_id])

    top_of_assignees = find_top_of_assignees(params[:id])
    labels = top_of_assignees[:top_of_assignees].map{|ta| ta[:name]}
    data = top_of_assignees[:top_of_assignees].map{|ta| ta[:count]}

    respond_to do |format|
      format.json { render json: {labels: labels, data: data}}
    end
  end

  def refresh_tasks
    status = params[:status]
    status ||= TCard.status.open
    @community = Community.find(params[:id])
    all_tcards = @community.find_tcards(status)
    @t_cards = Kaminari.paginate_array(all_tcards).page(params[:page]).per(5)
    @status = status
  end

  def update
    @community = Community.find(params[:id])
    respond_to do |format|
      if @community.update_attributes(name: params[:community][:name])
        @community = Community.find(params[:id])
        message = t('community.update.success')
        format.js { flash.now[:notice] = message }
        format.html { redirect_to @community, notice: message }
        format.json { head :no_content } # 204 No Content
      else
        format.js
        format.json { render json: {message: community.errors.full_messages.first}, status: :unprocessable_entity }
      end
    end
  end

  def invitable_users
    @community = Community.find(params[:id])
    invitable_users = User.find_invitable_users(@community, params[:q])
    respond_to do |format|
      format.js
      format.json { render json: invitable_users.as_json(only: ['id', 'nickname']) }  # セキュリティ的に必要最小限をレスポンスする
    end
  end

  def members
    @members = Community.find(params[:id]).find_users
  end

  def invite
    if params[:id].nil?
      # フロントJSで未選択の場合はボタンdisableにするが、それでもユーザー未指定でリクエストされた場合は、画面をリフレッシュする(chatwork理論)
      flash[:notice] = t('community.invitation.failure')
      redirect_to :action => :show and return
    end

    users = User.where(id: params[:user][:ids])
    community = Community.find(params[:id])
    users.each{ |user|
      unless user.joining?(community)
        user.invited(community)
      end
    }

    respond_to do |format|
      message = t('community.invitation.success', users: users.map(&:nickname).join(', '))
      format.js { flash.now[:notice] = message }
      format.html { redirect_to community, notice: message }
    end

  end

  def accept
    community = Community.find(params[:id])
    current_user.join_in(community)
    flash[:notice] = t('community.invitation.accept')
    redirect_to :action => :show
  end

  def decline
    community = Community.find(params[:id])
    current_user.decline(community)
    flash[:notice] = t('community.invitation.decline')
    redirect_to :controller => :mypages, :action => :show
  end

  def leave
    community = Community.find(params[:id])
    current_user.leave(community)
    flash[:notice] = t('community.leave')
    redirect_to :controller => :mypages, :action => :show
  end

  def remove
    community = Community.find(params[:id])
    user = User.find(params[:user_id])
    community.withdraw(user)

    respond_to do |format|
      message = t('community.remove', nickname: user.nickname)
      format.js { flash.now[:notice] = message }
      format.html { redirect_to community, notice: message }
    end

  end

  def destroy
    community = Community.find(params[:id])
    community.rest_in_place
    flash[:notice] = t('community.destroyed')
    redirect_to :controller => :mypages, :action => :show
  end

  def edit_task
    @task = TCard.find(params[:id]);
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

    def belongs_to?
      community = Community.find(params[:id])
      unless current_user.joining?(community)
        raise Forbidden
      end
    end

    # {
    # :top_of_assignees=>
    #   [{:name=>"nickname-1", :count=>5},
    #    {:name=>"nickname-2", :count=>4},
    #    {:name=>"nickname-3", :count=>4},
    #    {:name=>"nickname-4", :count=>4},
    #    {:name=>"nickname-5", :count=>4},
    #    {:name=>"others", :count=>22}]
    # }
    def find_top_of_assignees(community_id)
      top5 = Community.find(community_id).top_of_assignees.first(5)
      others = Community.find(community_id).top_of_assignees.to_a.from(5)
      top_of_assignees = Array.new
      top5.each { |i, j|
        data = { name: i, count: j }
        top_of_assignees.push(data)
      }

      if others.length > 0
        data = { name: "others", count: others.map{ |a| a[1] }.sum }
        top_of_assignees.push(data)
      end

      Hash["top_of_assignees": top_of_assignees]
    end
end
