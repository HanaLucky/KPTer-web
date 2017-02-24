class BoardsController < ApplicationController
  before_filter :store_location
  before_filter :authenticate_user!
  
  def create
    @board = Board.create(name: params[:board][:name], community_id: params[:community_id])
    redirect_to controller: 'boards', action: 'show', id: @board.id
  end
  def show
    # TODO: 仮実装。直接リンクで自分が所属しているコミュニティ以外のボードが見れないようにする？
    @board = Board.find(params[:id])
  end
end
