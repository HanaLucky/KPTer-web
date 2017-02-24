class CommunitiesController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!
  
  def show
    # TODO: コミュニティページ表示中にコミュニティから除名させられた場合の処理
    # https://github.com/HanaLucky/KPTer-web/issues/96
    @communities = User.find_communities_with_user_id(current_user.id)
    @community = Community.find(params[:id])
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
end
