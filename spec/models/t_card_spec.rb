require 'rails_helper'

RSpec.describe TCard, type: :model do

  describe "引数に指定されたTryカードIDに当たるカードのステータスを変更する" do

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

        @t_card_close = TCard.create(
          board_id: @board.id,
          title: "test_try_card3",
          detail: "closed status",
          status: TCard.status.closed
        )
      end

      it "OpenステータスがClosedになること" do
        TCard.update_status(@t_card_open.id)
        expect(TCard.find(@t_card_open.id).status).to eq(TCard.status.closed)
      end

      it "OpenステータスがClosedになること" do
        TCard.update_status(@t_card_close.id)
        expect(TCard.find(@t_card_close.id).status).to eq(TCard.status.open)
      end

    end

  end

end
