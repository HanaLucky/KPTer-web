require 'rails_helper'

# コミュニティ内のボード件数は、コミュニティ内のボードを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のTryカード件数は、コミュニティ内のt_cardsを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のユーザー数は、コミュニティ内のユーザーを全員取得した結果の件数とし、別途メソッドは作成しない。
RSpec.describe Community, type: :model do
  describe "コミュニティ内のボードを取得する" do
    before :all do
      # １コミュニティにボード３つ作成
      @community = Community.create(name: "community name")
      BOARD_NUM = 3.freeze
      for i in 1..BOARD_NUM do
        @board = Board.create(name: "board_#{i.to_s}", community_id: @community.id)
      end
      @boards = @community.find_boards
    end
    it "コミュニティに紐づくボードが取得できること" do
      expect(@boards).to be_present
    end
    it "作成された順であること(IDの降順)" do
      expect(@boards).to be_desc -> (board) { board.id }
    end
  end

  describe "コミュニティに紐づくt_cardsを取得する" do
    before :all do

      @user = FactoryGirl.create(:user)
      @community = Community.create(name: "community name")

      @board1 = Board.create(name: "board_1", community_id: @community.id)
      @t_card1_1 = TCard.create(
        board_id: @board1.id,
        title: "TCard_1_1",
        status: TCard.status.open,
        deadline: "2016/9/20",
        x: 120,
        y: 240,
        order: 1
      )
      @t_card1_2 = TCard.create(
        board_id: @board1.id,
        title: "TCard_1_2",
        status: TCard.status.closed,
        deadline: "2016/9/22",
        x: 120,
        y: 240,
        order: 1
      )
      @board2 = Board.create(name: "board_2", community_id: @community.id)
      @t_card2_1 = TCard.create(
        board_id: @board2.id,
        title: "TCard_2_1",
        status: TCard.status.open,
        deadline: "2016/1/23",
        x: 120,
        y: 240,
        order: 1
      )
      @t_card2_2 = TCard.create(
        board_id: @board2.id,
        title: "TCard_2_2",
        status: TCard.status.open,
        deadline: "2016/12/22",
        x: 120,
        y: 240,
        order: 2
      )

      @board3 = Board.create(name: "board_3", community_id: @community.id)
      @t_card3_1 = TCard.create(
        board_id: @board3.id,
        title: "TCard_3_1",
        status: TCard.status.open,
        deadline: "2016/9/20",
        x: 120,
        y: 240,
        order: 1
      )
      @t_card3_2 = TCard.create(
        board_id: @board3.id,
        title: "TCard_3_2",
        status: TCard.status.open,
        deadline: "2016/9/23",
        x: 120,
        y: 240,
        order: 2
      )
      @t_card3_3 = TCard.create(
        board_id: @board3.id,
        title: "TCard_3_3",
        status: TCard.status.closed,
        deadline: "2016/9/29",
        x: 120,
        y: 240,
        order: 3
      )
      @tcard_assignee1 = TcardAssignee.create(
        t_card_id: @t_card1_1.id,
        user_id: @user.id
      )
      @tcard_assignee2 = TcardAssignee.create(
        t_card_id: @t_card1_2.id,
        user_id: @user.id
      )
      @tcard_assignee3 = TcardAssignee.create(
        t_card_id: @t_card2_1.id,
        user_id: @user.id
      )
      @tcard_assignee4 = TcardAssignee.create(
        t_card_id: @t_card2_2.id,
        user_id: @user.id
      )
      @tcard_assignee5 = TcardAssignee.create(
        t_card_id: @t_card3_1.id,
        user_id: @user.id
      )
      @tcard_assignee6 = TcardAssignee.create(
        t_card_id: @t_card3_2.id,
        user_id: @user.id
      )
      @tcard_assignee7 = TcardAssignee.create(
        t_card_id: @t_card3_3.id,
        user_id: @user.id
      )
      @open_tcards = @community.find_tcards
      @closed_tcards = @community.find_tcards(TCard.status.closed)
    end

    it "コミュニティ内の全ボードから、Openのカードのみ取得できること" do
      expect(@open_tcards).to be_all -> t_card {
        t_card.status == TCard.status.open
      }
    end
    it "コミュニティ内の全ボードから、Closedのカードのみ取得できること" do
      expect(@closed_tcards).to be_all -> t_card {
        t_card.status == TCard.status.closed
      }
    end

    it "並び順が期限日の昇順であること" do
      expect(@open_tcards).to be_asc -> (t_card) { t_card.deadline }
      expect(@closed_tcards).to be_asc -> (t_card) { t_card.deadline }
    end
  end

  describe "コミュニティ内からユーザーを脱退させる" do
    before :all do
      @community = Community.create(name: "community name")
      @user = FactoryGirl.create(:user)
      # コミュニティに参加させる
      @community_user = CommunityUser.create(community_id: @community.id, user_id: @user.id)
      # 脱退する
      @community.withdraw(@user)
      @community_user = CommunityUser.where(community_id: @community.id, user_id: @user.id)

    end
    context "コミュニティに参加しているユーザーが退会する場合" do
      it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが削除されること" do
        expect(@community_user.empty?).to be true
      end
    end
    context "コミュニティに参加していないユーザーが退会する場合" do
      it "エラーが発生しないこと" do
        @community.withdraw(@user)
      end
    end
  end

  describe "コミュニティ内のユーザーを全員取得する" do
    before :all do
      # community_1に5ユーザーがあらわれた
      @community_1 = Community.create(name: "community_1")
      @user_1_1 = FactoryGirl.create(:user)
      @user_1_2 = FactoryGirl.create(:user)
      @user_1_3 = FactoryGirl.create(:user)
      @user_1_4 = FactoryGirl.create(:user)
      @user_1_5 = FactoryGirl.create(:user)
      # 4, 2, 1, 5, 3の順でコミュニティに参加した
      @users = [@user_1_4, @user_1_2, @user_1_1, @user_1_5, @user_1_3]
      @users.each{ |user|
        CommunityUser.create(community_id: @community_1.id, user_id: user.id)
      }

      # community_2に1ユーザーがあらわれた（ダミーデータ）
      @community_2 = Community.create(name: "community_2")
      @user_2_1 = FactoryGirl.create(:user)
      CommunityUser.create(community_id: @community_2.id, user_id: @user_2_1.id)

      # community_1のユーザーを全員取得する
      @joining_users = @community_1.find_users

    end
    it "コミュニティ内のユーザーが参加した順に取得できていること" do
      expect(@joining_users).to eq(@users)
    end
  end
end
