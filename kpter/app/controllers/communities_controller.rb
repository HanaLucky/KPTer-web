class CommunitiesController < ApplicationController
  def show
    # TODO: コミュニティページ表示中にコミュニティから除名させられた場合の処理
    # https://github.com/HanaLucky/KPTer-web/issues/96
    @community = Community.find(params[:id])
    @boards = @community.find_boards
  end
end