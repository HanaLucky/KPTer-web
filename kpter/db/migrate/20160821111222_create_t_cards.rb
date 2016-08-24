class CreateTCards < ActiveRecord::Migration[5.0]
  def change
    create_table :t_cards, comment: "Tカード" do |t|
      t.references :board, foreign_key: true, null: false, comment: "ボードID"
      t.string :title, comment: "タイトル"
      t.string :detail, limit: 512, comment: "詳細"
      t.references :user, foreing_key: true, comment: "担当者"
      t.date :deadline_on, comment: "期限"
      t.string :status, limit: 16, null: false, default: "open", comment: "ステータス¥topen, done"
      t.integer :x, null: false, default: 0, comment: "X座標"
      t.integer :y, null: false, default: 0, comment: "Y座標"
      t.integer :order, default: 0, comment: "重ね順"

      t.timestamps
    end
    add_index :t_cards, :status
  end
end
