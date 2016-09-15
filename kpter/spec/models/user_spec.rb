require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Userに紐付いたCommunityを新しい順に取得します。" do

    context "正常系" do

      before do
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

    before do
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

      before do
        @open_tcards = User.find_tcards_with_user_id(user_id: @user.id, status: TCard.status.open)
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

      before do
        @closed_tcards = User.find_tcards_with_user_id(user_id: @user.id, status: TCard.status.closed)
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

end
