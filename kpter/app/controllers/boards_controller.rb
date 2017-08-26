class BoardsController < ApplicationController
  before_action :authenticate_user!

  def create
    @board = Board.create(name: params[:board][:name], community_id: params[:community_id])
    if @board.errors.any?
      flash.keep[:alert] = @board.errors.full_messages.first
      redirect_to controller: 'communities', action: 'show', id: params[:community_id]
    else
      redirect_to controller: 'boards', action: 'show', id: @board.id
    end
  end

  def show
    # TODO: 仮実装。直接リンクで自分が所属しているコミュニティ以外のボードが見れないようにする？
    @board = Board.where(id: params[:id]).includes(:kp_cards).first
  end
end
