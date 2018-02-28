class CreateTCards < ActiveRecord::Migration[5.0]
  def change
    create_table :t_cards, comment: "Tカード" do |t|
      t.references :board, foreign_key: true, null: false, comment: "ボードID"
      t.integer :owner_id, foreign_key: true, null: false, comment: "カード作成者ID"
      t.string :title, comment: "タイトル"
      t.string :detail, limit: 512, comment: "詳細"
      t.date :deadline, comment: "期限"
      t.string :status, limit: 16, null: false, default: TCard.status.open, comment: "ステータス"
      t.integer :x, null: false, default: 0, comment: "X座標"
      t.integer :y, null: false, default: 0, comment: "Y座標"
      t.integer :order, default: 0, comment: "重ね順"

      t.timestamps
    end
    add_index :t_cards, :status
  end
end
