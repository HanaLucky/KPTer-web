class BoardsController < ApplicationController
  layout "board_layout"
  before_action :authenticate_user!, :side_column, only: [:show]

  def create
    @board = Board.create(name: params[:community][:boards][:name], community_id: params[:community_id])
    if @board.errors.any?
      flash.keep[:alert] = @board.errors.full_messages.first
      redirect_to controller: 'communities', action: 'show', id: params[:community_id]
    else
      redirect_to controller: 'boards', action: 'show', id: @board.id
    end
  end

  def show
    # TODO: 仮実装。直接リンクで自分が所属しているコミュニティ以外のボードが見れないようにする？
    @board = Board.includes(:memos, kp_cards: [:likes, :owner], t_cards: [:likes, :owner]).references(:memos, kp_cards: [:likes, :user], t_cards: [:likes, :user]).find(params[:id])
    @no_img = view_context.asset_path("noimages/profile.png")
  end
end
