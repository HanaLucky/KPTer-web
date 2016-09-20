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
      # 1コミュニティにボード３つ。それぞれのボードに３つのt_cardを作成
      BOARD_NUM = 3.freeze
      TCARD_NUM = 2.freeze

      @community = Community.create(name: "community name")

      for i in 1..BOARD_NUM do
        @board = Board.create(name: "board_#{i.to_s}", community_id: @community.id)
        for j in 1..TCARD_NUM do
          TCard.create(
            board_id: @board.id,
            title: "TCard_.#{j.to_s}",
            status: TCard.status.open,
            deadline: "2016/9/20",
            x: 120,
            y: 240,
            order: j
          )
        end
      end
      @t_cards = Community.find_tcards(@community.id)
    end
    it "コミュニティに紐づくt_cardsが取得できること" do
      expect(@t_cards).to be_present
      expect(@t_cards.length).to eq(TCARD_NUM)
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

  describe "コミュニティ内からユーザーが脱退する" do
    before :all do
      @community = Community.create(name: "community name")
      @user = FactoryGirl.create(:user)
      # コミュニティに参加させる
      @community.join(@user)
      # 脱退する
      @community.withdrawal(@user)
      count = CommunityUser.where(community_id: @community.id, user_id: @user.id).count
    end
    it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが削除されること" do
      expect(count).to eq(0)
    end
    # 既に除名済みかどうかのチェックは不要
  end

  describe "コミュニティ内のユーザーを全員取得する" do
    before :all do
      @community = Community.create(name: "community name")
      # user_1, 2, 3があらわれた
      @user_1 = FactoryGirl.create(:user)
      @user_2 = FactoryGirl.create(:user)
      @user_3 = FactoryGirl.create(:user)
      # user_1, 2, 3はコミュニティに参加した
      @community.join(@user_1)
      @community.join(@user_2)
      @community.join(@user_3)

      @joined_users = @community.find_users
      @community_user = CommunityUser.find_by(community_id: @community.id)
    end
    it "コミュニティ内のユーザーが全員取得できていること" do
      # ３人とれていること
      expect(@community_user.length).to eq(3)
      expect(@community_user.find_by(user_id: @user_1.id)).to be_present
      expect(@community_user.find_by(user_id: @user_2.id)).to be_present
      expect(@community_user.find_by(user_id: @user_3.id)).to be_present
    end
  end
end
