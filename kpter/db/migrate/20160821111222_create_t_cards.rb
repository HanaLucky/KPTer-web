class CreateTCards < ActiveRecord::Migration[5.0]
  def change
    create_table :t_cards do |t|
      t.references :board, foreign_key: true
      t.string :title
      t.string :detail
      t.string :status
      t.references :user, foreing_key: true
      t.integer :x
      t.integer :y
      t.integer :order

      t.timestamps
    end
  end
end
