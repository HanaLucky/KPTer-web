class CreateTcardAssignees < ActiveRecord::Migration[5.0]
  def change
    create_table :tcard_assignees, comment: "Tカード担当者" do |t|
      t.references :user, foreign_key: true, comment: "ユーザーID"
      t.references :t_card, foreign_key: true, comment: "TカードID"

      t.timestamps
    end
    add_index :tcard_assignees, [:user_id, :t_card_id], unique: true
  end
end
