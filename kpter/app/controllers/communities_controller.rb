class CommunitiesController < ApplicationController
  def show
    # TODO: コミュニティページ表示中にコミュニティから除名させられた場合の処理
    # https://github.com/HanaLucky/KPTer-web/issues/96
    @community = Community.find(params[:id])
    @all_boards = @community.find_boards
    @boards = Kaminari.paginate_array(@all_boards).page(params[:page]).per(10)
    @tasks = @community.find_tcards
    @attendees = @community.find_users
  end
end
