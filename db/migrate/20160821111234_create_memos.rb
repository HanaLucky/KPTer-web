class CreateMemos < ActiveRecord::Migration[5.0]
  def change
    create_table :memos, comment: "メモ" do |t|
      t.references :board, foreign_key: true, null: false, comment: "ボードID"
      t.text :contents, comment: "内容"
      t.integer :x, null: false, default: 0, comment: "X座標"
      t.integer :y, null: false, default: 0, comment: "Y座標"
      t.integer :order, default: 0, comment: "重ね順"

      t.timestamps
    end
  end
end
