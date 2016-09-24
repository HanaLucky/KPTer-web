require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Userに紐付いたCommunityを新しい順に取得します。" do

    context "正常系" do

      before :all do
        @user = FactoryGirl.create(:user)
        @community = Community.create(
          name: "test_community"
        )
        @community2 = Community.create(
          name: "test_community2"
        )
        @cu = CommunityUser.create(
          user_id: @user.id,
          community_id: @community.id
        )
        @cu2 = CommunityUser.create(
          user_id: @user.id,
          community_id: @community2.id
        )

        @communities = User.find_communities_with_user_id(@user.id)
      end

      it "Userに紐付いたCommunityが取得できること" do
        expect(@communities).to be_present
      end

      it "CommunityのIDの降順で取得できること" do
        expect(@communities).to be_desc -> (community) { community.id }
      end

    end

  end

  describe "Userに紐付いたTCardを引数があれば、statusで絞込、期限でソートして取得します。" do

    before :all do
      @user = FactoryGirl.create(:user)
      @community = Community.create(
        name: "test_community"
      )
      @community2 = Community.create(
        name: "test_community2"
      )
      @cu = CommunityUser.create(
        user_id: @user.id,
        community_id: @community.id
      )
      @cu2 = CommunityUser.create(
        user_id: @user.id,
        community_id: @community2.id
      )

      @board = Board.create(
        community_id: @community.id,
        name: "test_board_name"
      )

      @t_card_open = TCard.create(
        board_id: @board.id,
        title: "test_try_card1",
        detail: "default status (open)",
        status: TCard.status.open
      )

      @t_card_open2 = TCard.create(
        board_id: @board.id,
        title: "test_try_card2",
        detail: "default status (open)",
        status: TCard.status.open
      )

      @t_card_close = TCard.create(
        board_id: @board.id,
        title: "test_try_card3",
        detail: "closed status",
        status: TCard.status.closed
      )
      @t_card_close2 = TCard.create(
        board_id: @board.id,
        title: "test_try_card4",
        detail: "closed status",
        status: TCard.status.closed
      )

    end

    context "引数なし" do

      before :all do
        @open_tcards = User.find_tcards_with_user_id(@user.id, TCard.status.open)
      end

      it "Userに紐づくTCardが取得できること" do
        expect(@open_tcards).to be_present
      end

      it "OpenなstatusのTCardが取得できること" do
        expect(@open_tcards).to be_all -> t_card {
          t_card.status == TCard.status.open
        }
      end

      it "期限日昇順でTCardが取得できること" do
        expect(@open_tcards).to be_asc -> (t_card) { t_card.deadline }
      end

    end

    context "引数両方" do

      before :all do
        @closed_tcards = User.find_tcards_with_user_id(@user.id, TCard.status.closed)
      end

      it "Userに紐づくTCardが取得できること" do
        expect(@closed_tcards).to be_present
      end

      it "CloseなstatusのTCardが取得できること" do
        expect(@closed_tcards).to be_all -> t_card {
          t_card.status == TCard.status.closed
        }
      end

      it "期限日昇順でTCardが取得できること" do
        expect(@closed_tcards).to be_asc -> (t_card) { t_card.deadline }
      end

    end

  end

  describe "コミュニティ内に既に参加済みかどうかチェックする" do

    before :all do
      # コミュニティに１ユーザー参加させる
      @community = Community.create(name: "community name")
      @joining_user = FactoryGirl.create(:user)
      @community_user = CommunityUser.create(
        community_id: @community.id,
        user_id: @joining_user.id
      )
      # コミュニティに属さないユーザを作成する
      @unjoining_user = FactoryGirl.create(:user)
    end

    context "参加済みの場合" do

      it "trueが返却されること" do
        expect(@joining_user.joining?(@community)).to be_truthy
      end

    end

    context "参加していない場合" do

      it "falseが返却されること" do
        expect(@unjoining_user.joining?(@community)).to be_falsey
      end

    end

  end

  describe "ユーザーが特定のコミュニティに参加する" do

    before :all do
      @community = Community.create(name: "community name")
      @user = FactoryGirl.create(:user)
      # コミュニティに参加させる
      @user.join_in(@community)
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
        cu = @user.join_in(@community)
        cu.valid?
        expect(cu.errors[:user_id]).to include(I18n.t('activerecord.errors.models.user.attributes.user_id.taken'))
      end

      it "コミュニティ・ユーザー関連テーブルに２重に登録されていないこと" do
        count = CommunityUser.where(community_id: @community.id, user_id: @user.id).count
        expect(count).to eq(1)
      end

    end

  end

end
