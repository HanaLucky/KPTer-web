require 'rails_helper'

RSpec.describe User, type: :model do

  describe "Userに紐付いたCommunityを新しい順に取得します。" do

    context "正常系" do

      it "Userが取得できること" do
      end

      it "Userに関連するCommunityUserが取得できること" do
      end

      it "CommunityUserに関連するCommunityが取得できること" do
      end

      it "CommunityのIDの降順で取得できること" do
      end

    end

  end

  describe "Userに紐付いたTCardを引数があれば、statusで絞込、期限でソートして取得します。" do

    context "引数なし" do

      it "Userが取得できること" do
      end

      it "Userに関連するCommunityUserが取得できること" do
      end

      it "CommunityUserに関連するCommunityが取得できること" do
      end

      it "Community関連するBoardが取得できること" do
      end

      it "Board関連するTCardが取得できること" do
      end

      it "OpenなstatusのTCardが取得できること" do
      end

      it "TCardの期限日昇順でBoardが取得できること" do
      end

    end

    context "引数両方" do

      it "Userが取得できること" do
      end

      it "Userに関連するCommunityUserが取得できること" do
      end

      it "CommunityUserに関連するCommunityが取得できること" do
      end

      it "Community関連するBoardが取得できること" do
      end

      it "Board関連するTCardが取得できること" do
      end

      it "CloseなstatusのTCardが取得できること" do
      end

      it "TCardの期限日降順でBoardが取得できること" do
      end

    end

  end

  describe "Userに紐付いた画像を登録／変更する。" do

    context "正常系" do

      it "画像が存在すること" do
      end

      it "登録した画像であること" do
      end

    end

  end

end
