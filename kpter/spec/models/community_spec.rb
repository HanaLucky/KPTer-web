require 'rails_helper'

# コミュニティ内のボード件数は、コミュニティ内のボードを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のTryカード件数は、コミュニティ内のt_cardsを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のユーザー数は、コミュニティ内のユーザーを全員取得した結果の件数とし、別途メソッドは作成しない。
# TODO: コミュニティ招待用URLの発行の実現方法
RSpec.describe Community, type: :model do
  describe "コミュニティ内にボードをつくる" do
    it "作成されたボードのコミュニティIDが引数に渡したものと一致すること" do
    end
  end

  describe "コミュニティに関連する情報を取得する" do
    it "指定したコミュニティIDに紐づくコミュニティが取得できること" do
    end
    it "コミュニティに紐づくボードが取得できること" do
    end
    it "ボードに紐づくt_cardsが取得できること" do
    end
  end

  describe "コミュニティに紐づくt_cardsを取得する" do
    it "t_cardsの数がinputで入れたデータの数に一致すること" do
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
