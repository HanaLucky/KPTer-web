require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Userに紐付いたCommunityを新しい順に取得します。" do

    context "正常系" do

      before do
        @user = User.find(1)
        @communities = @user.find_communitys
      end

      it "Userに紐付いたCommunityが取得できること" do
        expect(@communities).to be_present
      end

      it "CommunityのIDの降順で取得できること" do
        expect(@communities).to be_desc = -> (community) { community.id }
      end

    end

  end

  describe "Userに紐付いたTCardを引数があれば、statusで絞込、期限でソートして取得します。" do

    context "引数なし" do

      before do
        @user = User.find(1)
        @t_cards = @user.find_tcards
      end

      it "Userに紐づくTCardが取得できること" do
        expect(@t_cards).to be_present
      end

      it "OpenなstatusのTCardが取得できること" do
        expect(@t_cards).to be_all -> t_card {
          t_card == "Open"
        }
      end

      it "期限日昇順でTCardが取得できること" do
        expect(@t_cards).to be_asc = -> (t_card) { t_card.deadline }
      end

    end

    context "引数両方" do

      before do
        @user = User.find(1)
        @t_cards = @user.find_tcards
      end

      it "Userに紐づくTCardが取得できること" do
        expect(@t_cards).to be_present
      end

      it "CloseなstatusのTCardが取得できること" do
        expect(@t_cards).to be_all -> t_card {
          t_card == "Closed"
        }
      end

      it "期限日昇順でTCardが取得できること" do
        expect(@t_cards).to be_asc = -> (t_card) { t_card.deadline }
      end

    end

  end

end
