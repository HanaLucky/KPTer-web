class CreateKpCards < ActiveRecord::Migration[5.0]
  def change
    create_table :kp_cards do |t|
      t.references :board, foreign_key: true
      t.string :title
      t.string :detail
      t.string :type
      t.integer :x
      t.integer :y
      t.integer :order

      t.timestamps
    end
  end
end
