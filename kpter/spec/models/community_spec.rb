require 'rails_helper'

# コミュニティ内のボード件数は、コミュニティ内のボードを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のTryカード件数は、コミュニティ内のt_cardsを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のユーザー数は、コミュニティ内のユーザーを全員取得した結果の件数とし、別途メソッドは作成しない。
# TODO: コミュニティ招待用URLの発行の実現方法
RSpec.describe Community, type: :model do
  before :all do
    # CommunityモデルのSpecで利用するテストデーター作成
    # データー概要
    # 1.コミュニティにBOARD_NUM個のボードを作成。
    # 2. それぞれのボードにTCARD_NUM個のt_cardを作成。
    # 3コミュニティが複数のパターンを想定した検証ではないので、コミュニティは１個
    BOARD_NUM = 3
    TCARD_NUM = 2

    @community = Community.create(name: "community name")
    for i in 1..BOARD_NUM do
      @board = Board.create(name: "board_" +i.to_s, community_id: @community.id)
      for j in 1..TCARD_NUM do
        TCard.create(
          board_id: @board.id,
          title: "TCard_" + j.to_s,
          status: TCard.statuses[:open],
          deadline: "2016/9/20",
          x: 120,
          y: 240,
          order: j
        )
      end
    end
  end

  describe "コミュニティ内のボードを取得する" do
    it "コミュニティに紐づくボードが取得できること" do
      @boards = Community.find_boards(@community.id)
      expect(@boards).to be_present
    end
    it "コミュニティに紐づくボードの数が一致すること" do
      @boards = Community.find_boards(@community.id)
      expect(@boards.length).to eq(BOARD_NUM)
    end
  end

  describe "コミュニティに紐づくt_cardsを取得する" do
    before :all do
      @t_cards = Community.find_t_cards(@community.id)
    end
    it "コミュニティに紐づくt_cardsが取得できること" do
      expect(@t_cards).to be_present
    end
    it "コミュニティに紐づくt_cardsが取得できること" do
      expect(@t_cards).to eq(TCARD_NUM)
    end
  end

  describe "コミュニティ内に既に参加済みかどうかチェックする" do
    context "参加済みの場合" do
      it "trueが返却されること" do
      end
    end
    context "参加していない場合" do
      it "falseが返却されること" do
      end
    end
  end

  describe "コミュニティ内にユーザーを参加させる" do
    context "参加していない場合" do
      it "コミュニティ・ユーザー関連テーブルに登録したコミュニティIDが引数に指定したIDと一致すること" do
      end
      it "コミュニティ・ユーザー関連テーブルに登録したユーザーIDが引数に指定したIDと一致すること" do
      end
    end
    context "既に参加している場合" do
      it "エラーメッセージが設定されること" do
      end
      it "コミュニティ・ユーザー関連テーブルに登録されていないこと" do
      end
    end
  end

  describe "コミュニティ内からユーザーを除名する" do
    it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが削除されること" do
    end
    # 既に除名済みかどうかのチェックは不要
  end

  describe "コミュニティ内のユーザーを全員取得する" do
    it "コミュニティIDに紐づくコミュニティ・ユーザー関連テーブルが取得できること" do
    end
    it "コミュニティ・ユーザー関連テーブルのユーザーIDに紐づくユーザーが取得できること" do
    end
  end
end
