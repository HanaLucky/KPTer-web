class CreateBoards < ActiveRecord::Migration[5.0]
  def change
    create_table :boards, comment: "ボード" do |t|
      t.references :community, foreign_key: true, null: false, comment: "コミュニティID"
      t.string :name, null: false, comment: "ボード名"

      t.timestamps
    end
  end
end
