class CreateMemos < ActiveRecord::Migration[5.0]
  def change
    create_table :memos do |t|
      t.references :board, foreign_key: true
      t.text :contents
      t.integer :x
      t.integer :y
      t.integer :order

      t.timestamps
    end
  end
end
