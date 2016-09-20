require 'rails_helper'

# コミュニティ内のボード件数は、コミュニティ内のボードを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のTryカード件数は、コミュニティ内のt_cardsを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のユーザー数は、コミュニティ内のユーザーを全員取得した結果の件数とし、別途メソッドは作成しない。
# TODO: コミュニティ招待用URLの発行の実現方法
RSpec.describe Community, type: :model do
  describe "コミュニティ内のボードを取得する" do
    before :all do
      # １コミュニティにボード３つ作成
      BOARD_NUM = 3.freeze
      @community = Community.create(name: "community name")
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

  describe "コミュニティ内に既に参加済みかどうかチェックする" do
    before :all do
      # コミュニティに１ユーザー参加させる
      @community = Community.create(name: "community name")
      @joined_user = FactoryGirl.create(:user)
      @community_user = CommunityUser.create(
        community_id: @community.id,
        user_id: @joined_user.id
      )
      # コミュニティに属さないユーザを作成する
      @unjoined_user = FactoryGirl.create(:user)
    end
    context "参加済みの場合" do
      it "trueが返却されること" do
        expect(@community.joined(@joined_user)).to be_true
      end
    end
    context "参加していない場合" do
      it "falseが返却されること" do
        expect(@community.joined(@unjoined_user)).to be_false
      end
    end
  end

  describe "コミュニティ内にユーザーを参加させる" do
    before :all do
      @community = Community.create(name: "community name")
      @user = FactoryGirl.create(:user)
      # コミュニティに参加させる
      @community.join(@user)
      @community_user = CommunityUser.find_by(community_id: @community.id, user_id: @user.id)
    end
    context "まだ参加していないコミュニティに参加する場合" do
      it "コミュニティ・ユーザー関連テーブルに登録したコミュニティIDが引数に指定したIDと一致すること" do
        expect(@community_user).to be_present
        expect(@community_user.community_id).to eq(@community.id)
      end
      it "コミュニティ・ユーザー関連テーブルに登録したユーザーIDが引数に指定したIDと一致すること" do
        expect(@community_user.user_id).to eq(@user.id)
      end
    end
    context "既に参加しているコミュニティに参加する場合" do
      it "エラーメッセージが設定されること" do
        # 再度、同じコミュニティに参加させてエラーを発生させる
        @community.join(@user)
        @community.should have(1).errors_on(:user_id)
      end
      it "コミュニティ・ユーザー関連テーブルに２重に登録されていないこと" do
        count = CommunityUser.where(community_id: @community.id, user_id: @user.id).count
        expect(count).to eq(1)
      end
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
    it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが削除されること" do
      expect(@community_user.empty?).to be true
    end
    # 既に除名済みかどうかのチェックは不要
  end

  describe "コミュニティ内のユーザーを全員取得する" do
    before :all do
      @community = Community.create(name: "community name")
      # user_1, 2, 3, 4, 5があらわれた
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)
      @user_4 = FactoryGirl.create(:user)
      @user_5 = FactoryGirl.create(:user)

      # user_4, 2, 1, 5, 3の順でコミュニティに参加した
      CommunityUser.create(community_id: @community.id, user_id: @user_4.id)
      CommunityUser.create(community_id: @community.id, user_id: @user_2.id)
      CommunityUser.create(community_id: @community.id, user_id: @user_1.id)
      CommunityUser.create(community_id: @community.id, user_id: @user_5.id)
      CommunityUser.create(community_id: @community.id, user_id: @user_3.id)

      @joining_users = @community.find_users

    end
    it "コミュニティ内のユーザーが全員取得できていること" do
      expect(@joining_users.count()).to eq(5)
      expect(@joining_users.find(id: @user_1.id)).to be_present
      expect(@joining_users.find(id: @user_2.id)).to be_present
      expect(@joining_users.find(id: @user_3.id)).to be_present
      expect(@joining_users.find(id: @user_4.id)).to be_present
      expect(@joining_users.find(id: @user_5.id)).to be_present
    end
    it "並び順が参加した順(IDの昇順)になっている" do
      expect(@joining_users[0].id).to eq(@user_4.id)
      expect(@joining_users[1].id).to eq(@user_2.id)
      expect(@joining_users[2].id).to eq(@user_1.id)
      expect(@joining_users[3].id).to eq(@user_5.id)
      expect(@joining_users[4].id).to eq(@user_3.id)
    end
  end
end
