require 'rails_helper'

# コミュニティ内のボード件数は、コミュニティ内のボードを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のTryカード件数は、コミュニティ内のt_cardsを全て取得した結果の件数とし、別途メソッドは作成しない。
# コミュニティ内のユーザー数は、コミュニティ内のユーザーを全員取得した結果の件数とし、別途メソッドは作成しない。
# TODO: コミュニティ招待用URLの発行の実現方法
RSpec.describe Community, type: :model do
  describe "コミュニティを新規に作成する" do
    it "登録されること" do
    end
  end

  describe "コミュニティを更新する" do
    it "更新されること" do
    end
  end

  describe "コミュニティを削除する" do
    it "削除されること" do
    end
  end

  describe "コミュニティ内にボードをつくる" do
    it "コミュニティIDに紐づくボードが登録されること" do
    end
  end

  describe "コミュニティ内のボードを全て取得する" do
    it "コミュニティIDに紐づくボードが全て取得できること" do
    end
  end

  describe "コミュニティ内のt_cardsを全て取得する" do
    it "コミュニティに紐づくボードが取得できること" do
    end
    it "ボードに紐づくt_cardsが全て取得できること" do
    end
  end

  describe "コミュニティ内にユーザーを参加させる" do
    it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが登録されること" do
    end
  end

  describe "コミュニティ内からユーザーを除名する" do
    it "コミュニティID, ユーザーIDに紐づくコミュニティ・ユーザー関連テーブルが削除されること" do
    end
  end
  describe "コミュニティ内のユーザーを全員取得する" do
    it "コミュニティIDに紐づくコミュニティ・ユーザー関連テーブルが取得できること" do
    end
    it "コミュニティ・ユーザー関連テーブルのユーザーIDに紐づくユーザーが取得できること" do
    end
  end
end
