class MypagesController < ApplicationController
  def show
    @communities = User.find_communities_with_user_id(current_user.id)
    @all_tcards = User.find_tcards_with_user_id(current_user.id)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page])
    @community = Community.new
  end

  def toggle
      render nothing: true
      TCard.update_status(params[:id])
  end

  def refresh_tasks
    status = params[:status]
    status ||= TCard.status.open
    @all_tcards = User.find_tcards_with_user_id(current_user.id, status)
    @t_cards = Kaminari.paginate_array(@all_tcards).page(params[:page])
  end

  def create_community
    @community = Community.new(name: params[:community][:name])

    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @community.save
          @community_user = CommunityUser.new(user_id: current_user.id, community_id: @community.id)
          if @community_user.save
            format.html { redirect_to @community, notice: 'Community was successfully created.' }
            format.json { render :show, status: :created, location: @community }
          else
            format.html { render :show }
          end
        else
          format.html { render :show }
        end
      end
    end
  end
end
